part of 'withdraw_cubit.dart';

sealed class WithdrawState extends Equatable {
  const WithdrawState();

  @override
  List<Object> get props => [];
}

final class WithdrawInitial extends WithdrawState {}

final class WithdrawLoading extends WithdrawState {}

final class WithdrawSuccess extends WithdrawState {
  final String message;

  const WithdrawSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class TransactionLoading extends WithdrawState {}

final class TransactionSuccess extends WithdrawState {
  final String message;

  const TransactionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class WithdrawError extends WithdrawState {
  final String message;

  const WithdrawError(this.message);

  @override
  List<Object> get props => [message];
}
