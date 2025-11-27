import 'package:dio/dio.dart';
import '../models/withdrawal_request_model.dart';
import '../models/withdrawal_response_model.dart';
import '../models/transaction_request_model.dart';
import '../models/transaction_response_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/constants.dart';

abstract class WithdrawRemoteDataSource {
  Future<WithdrawalResponseModel> createWithdrawalRequest(
    WithdrawalRequestModel request,
    String authorization,
  );

  Future<TransactionResponseModel> createTransaction(
    TransactionRequestModel request,
    String authorization,
  );
}

class WithdrawRemoteDataSourceImpl implements WithdrawRemoteDataSource {
  final Dio dio;
  final ApiService apiService;

  WithdrawRemoteDataSourceImpl({required this.dio, required this.apiService});

  @override
  Future<WithdrawalResponseModel> createWithdrawalRequest(
    WithdrawalRequestModel request,
    String authorization,
  ) async {
    try {
      print('📤 Creating withdrawal request');
      print(
        '📤 Authorization header: ${authorization.substring(0, authorization.length > 30 ? 30 : authorization.length)}...',
      );
      print(
        '📤 Full URL will be: ${AppConstants.baseUrl}/api/v1/owner/withdrawal_requests',
      );
      print('📤 Request body: ${request.toJson()}');

      final response = await apiService.createWithdrawalRequest(
        request,
        authorization,
      );

      print('✅ Withdrawal request response status: ${response.statusCode}');
      print('✅ Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        return WithdrawalResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          'Failed to create withdrawal request. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Error response: ${e.response?.data}');
      print('❌ Error status code: ${e.response?.statusCode}');
      print('❌ Error request path: ${e.requestOptions.path}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Unable to connect to server. Please check if the API URL is correct and your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final errorMessage =
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            'Server error occurred';
        throw ServerException('Server error (${statusCode}): $errorMessage');
      } else if (e.type == DioExceptionType.unknown) {
        final error = e.error;
        print('❌ Underlying error: $error');

        if (error != null) {
          final errorString = error.toString();
          if (errorString.contains('type') ||
              errorString.contains('cast') ||
              errorString.contains('fromJson') ||
              errorString.contains('FormatException')) {
            print('❌ This appears to be a JSON parsing error');
            throw ServerException(
              'Failed to parse server response. The response format may be incorrect.',
            );
          }
          throw NetworkException('Network error: ${error.toString()}');
        } else {
          throw NetworkException(
            'Unknown network error. Please check your internet connection and try again.',
          );
        }
      } else {
        throw NetworkException(
          'Network error occurred: ${e.message ?? "Unknown error"}',
        );
      }
    } catch (e, stackTrace) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      print('❌ Unexpected error type: ${e.runtimeType}');
      print('❌ Unexpected error: $e');
      print('❌ Stack trace: $stackTrace');

      final errorString = e.toString();
      if (errorString.contains('type') ||
          errorString.contains('cast') ||
          errorString.contains('fromJson') ||
          errorString.contains('FormatException')) {
        throw ServerException(
          'Failed to parse server response. Please check the API response format.',
        );
      }

      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<TransactionResponseModel> createTransaction(
    TransactionRequestModel request,
    String authorization,
  ) async {
    try {
      print('📤 Creating transaction');
      print(
        '📤 Authorization header: ${authorization.substring(0, authorization.length > 30 ? 30 : authorization.length)}...',
      );
      print(
        '📤 Full URL will be: ${AppConstants.baseUrl}/api/v1/owner/transactions',
      );
      print('📤 Request body: ${request.toJson()}');

      final response = await apiService.createTransaction(
        request,
        authorization,
      );

      print('✅ Transaction response status: ${response.statusCode}');
      print('✅ Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        return TransactionResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          'Failed to create transaction. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Error response: ${e.response?.data}');
      print('❌ Error status code: ${e.response?.statusCode}');
      print('❌ Error request path: ${e.requestOptions.path}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Unable to connect to server. Please check if the API URL is correct and your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final errorMessage =
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            'Server error occurred';
        throw ServerException('Server error (${statusCode}): $errorMessage');
      } else if (e.type == DioExceptionType.unknown) {
        final error = e.error;
        print('❌ Underlying error: $error');

        if (error != null) {
          final errorString = error.toString();
          if (errorString.contains('type') ||
              errorString.contains('cast') ||
              errorString.contains('fromJson') ||
              errorString.contains('FormatException')) {
            print('❌ This appears to be a JSON parsing error');
            throw ServerException(
              'Failed to parse server response. The response format may be incorrect.',
            );
          }
          throw NetworkException('Network error: ${error.toString()}');
        } else {
          throw NetworkException(
            'Unknown network error. Please check your internet connection and try again.',
          );
        }
      } else {
        throw NetworkException(
          'Network error occurred: ${e.message ?? "Unknown error"}',
        );
      }
    } catch (e, stackTrace) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      print('❌ Unexpected error type: ${e.runtimeType}');
      print('❌ Unexpected error: $e');
      print('❌ Stack trace: $stackTrace');

      final errorString = e.toString();
      if (errorString.contains('type') ||
          errorString.contains('cast') ||
          errorString.contains('fromJson') ||
          errorString.contains('FormatException')) {
        throw ServerException(
          'Failed to parse server response. Please check the API response format.',
        );
      }

      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
