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

    final request = WithdrawalRequestModel(
      withdrawalRequest: WithdrawalRequest(
        points: points,
        phoneNumber: phoneNumber,
        method: method,
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
    required String kioskNumber,
    String? paymentMethod,
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
      points: points,
      kioskNumber: kioskNumber,
      paymentMethod: paymentMethod,
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
}
