import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:coinly/core/network/api_service.dart';
import 'package:coinly/core/utils/constants.dart';
import 'package:coinly/core/utils/message_extractor.dart';
import 'package:coinly/features/auth/data/models/login_request_model.dart';
import 'package:coinly/features/auth/data/models/login_response_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required ApiService apiService,
    required Dio dio,
    required SharedPreferences sharedPreferences,
  }) : _apiService = apiService,
       _dio = dio,
       _sharedPreferences = sharedPreferences,
       super(const LoginState());

  final ApiService _apiService;
  final Dio _dio;
  final SharedPreferences _sharedPreferences;

  void selectRole(String role) {
    emit(state.copyWith(selectedRole: role, errorMessage: null));
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  void clearAction() {
    if (state.action != LoginFlowAction.none) {
      emit(state.copyWith(action: LoginFlowAction.none));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final validationError = _validateInputs(
      username,
      password,
      state.selectedRole,
    );

    if (validationError != null) {
      emit(state.copyWith(errorMessage: validationError));
      return;
    }

    final role = state.selectedRole!;

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        action: LoginFlowAction.none,
      ),
    );

    try {
      final roleConfig = _resolveRole(role);
      final request = LoginRequestModel(
        grantType: 'password',
        clientId: roleConfig.clientId,
        clientSecret: roleConfig.clientSecret,
        username: username.trim(),
        password: password,
        scope: roleConfig.scope,
      );

      final rawResponse = await _fetchRawResponse(request);
      final parsedResponse = await _apiService.login(request);
      final token = _extractToken(parsedResponse, rawResponse);

      if (token == null || token.isEmpty) {
        throw Exception('Access token not received from server');
      }

      await _sharedPreferences.setString(AppConstants.accessToken, token);

      emit(state.copyWith(isLoading: false, action: LoginFlowAction.home));
    } on DioException catch (e) {
      final navigation = _mapStatusToAction(e.response?.statusCode);
      if (navigation != null) {
        emit(state.copyWith(isLoading: false, action: navigation));
        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: _mapDioErrorToMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'حدث خطأ أثناء تسجيل الدخول',
        ),
      );
    }
  }

  ({String clientId, String clientSecret, String scope}) _resolveRole(
    String role,
  ) {
    switch (role) {
      case 'owner':
        return (
          clientId: AppConstants.ownerClientId,
          clientSecret: AppConstants.ownerClientSecret,
          scope: 'owner',
        );
      case 'worker':
        return (
          clientId: AppConstants.workerClientId,
          clientSecret: AppConstants.workerClientSecret,
          scope: 'worker',
        );
      default:
        throw Exception('Role not selected');
    }
  }

  Future<Response<dynamic>> _fetchRawResponse(LoginRequestModel request) async {
    return _dio.post<dynamic>('/oauth/token', data: request.toJson());
  }

  String? _extractToken(
    LoginResponseModel parsedResponse,
    Response<dynamic> rawResponse,
  ) {
    String? token = parsedResponse.accessToken;

    if (token != null && token.isNotEmpty) {
      return token;
    }

    final data = rawResponse.data;
    if (data is Map) {
      token = _findTokenInMap(data);
    }

    return token;
  }

  String? _findTokenInMap(Map<dynamic, dynamic> data) {
    const possibleKeys = ['access_token', 'accessToken', 'token', 'auth_token'];

    for (final key in possibleKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    final nestedCandidates = ['user', 'meta', 'data'];
    for (final candidate in nestedCandidates) {
      final nested = data[candidate];
      if (nested is Map) {
        final token = _findTokenInMap(nested);
        if (token != null && token.isNotEmpty) {
          return token;
        }
      }
    }

    return null;
  }

  String? _validateInputs(String username, String password, String? role) {
    if (username.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني أو اسم المستخدم';
    }

    if (password.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }

    if (role == null) {
      return 'يرجى اختيار نوع المستخدم';
    }

    return null;
  }

  LoginFlowAction? _mapStatusToAction(int? statusCode) {
    switch (statusCode) {
      case 403:
        return LoginFlowAction.ownerAccess;
      case 423:
        return LoginFlowAction.blockedUser;
      default:
        return null;
    }
  }

  String _mapDioErrorToMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال. حاول مرة أخرى';
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'تحقق من اتصالك بالإنترنت';
    }
  }

  String _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // For OAuth2 errors, prioritize error_description
    // Check directly for error_description first (before using MessageExtractor)
    if (data is Map<String, dynamic> && data['error_description'] != null) {
      final errorDescription = data['error_description'];
      if (errorDescription is String && errorDescription.isNotEmpty) {
        return errorDescription;
      }
    }

    // Use MessageExtractor to get the error message from API response
    final extractedMessage = MessageExtractor.extractErrorFromDioException(data);

    // If we got a meaningful message from the API, use it
    if (extractedMessage.isNotEmpty &&
        extractedMessage != 'حدث خطأ غير متوقع') {
      return extractedMessage;
    }

    // Fallback to status code specific messages if API didn't provide a message
    if (statusCode == 401) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    }

    if (statusCode == 400) {
      // For 400 errors, check if it's an OAuth error with invalid_grant
      if (data is Map<String, dynamic> && 
          data['error'] == 'invalid_grant' &&
          data['error_description'] == null) {
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      }
      return 'طلب غير صحيح. تحقق من البيانات المدخلة';
    }

    if (statusCode == 404) {
      return 'نقطة الاتصال غير موجودة';
    }

    if (statusCode == 500) {
      return 'خطأ في الخادم. حاول مرة أخرى لاحقاً';
    }

    return extractedMessage.isNotEmpty
        ? extractedMessage
        : 'حدث خطأ أثناء تسجيل الدخول';
  }
}
