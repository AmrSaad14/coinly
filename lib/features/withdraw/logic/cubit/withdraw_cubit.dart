import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../data/repository/withdraw_repository.dart';
import '../../data/models/withdrawal_request_model.dart';
import '../../data/models/transaction_request_model.dart';

part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  final WithdrawRepository repository;
  final SharedPreferences sharedPreferences;

  WithdrawCubit({
    required this.repository,
    required this.sharedPreferences,
  }) : super(WithdrawInitial());

  Future<void> createWithdrawalRequest({
    required int points,
    required String phoneNumber,
    required String method,
  }) async {
    emit(WithdrawLoading());

    // Get access token from SharedPreferences
    final accessToken = sharedPreferences.getString(AppConstants.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      emit(const WithdrawError('لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';

    final apiMethod = _mapWithdrawMethod(method);

    final request = WithdrawalRequestModel(
      withdrawalRequest: WithdrawalRequest(
        points: points,
        phoneNumber: phoneNumber,
        method: apiMethod,
      ),
    );

    final result = await repository.createWithdrawalRequest(
      request,
      authorization,
    );

    result.fold(
      (failure) => emit(WithdrawError(_mapFailureToMessage(failure))),
      (response) => emit(WithdrawSuccess(response.message)),
    );
  }

  Future<void> createTransaction({
    required int points,
    required String clientPhoneNumber,
    required int marketId,
  }) async {
    emit(TransactionLoading());

    // Get access token from SharedPreferences
    final accessToken = sharedPreferences.getString(AppConstants.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      emit(const WithdrawError('لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';

    final request = TransactionRequestModel(
      transaction: TransactionBody(
        clientPhoneNumber: clientPhoneNumber,
        marketId: marketId,
        pointsTotal: points,
      ),
    );

    final result = await repository.createTransaction(
      request,
      authorization,
    );

    result.fold(
      (failure) => emit(WithdrawError(_mapFailureToMessage(failure))),
      (response) => emit(TransactionSuccess(response.message)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return failure.message;
      default:
        return 'حدث خطأ غير متوقع';
    }
  }

  String _mapWithdrawMethod(String method) {
    final normalized = method.trim();

    if (normalized.contains('انستاباي')) {
      return 'instapay';
    }

    // You can extend this mapping if backend expects specific keys
    // for other Arabic labels (e.g. vodafone_cash, orange_cash, etc.).
    return normalized;
  }
}
