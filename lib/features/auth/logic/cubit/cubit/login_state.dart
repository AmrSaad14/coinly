part of 'login_cubit.dart';

enum LoginFlowAction {
  none,
  home,
  ownerAccess,
  blockedUser,
}

final class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.selectedRole,
    this.errorMessage,
    this.action = LoginFlowAction.none,
  });

  final bool isLoading;
  final String? selectedRole;
  final String? errorMessage;
  final LoginFlowAction action;

  static const Object _sentinel = Object();

  LoginState copyWith({
    bool? isLoading,
    Object? selectedRole = _sentinel,
    Object? errorMessage = _sentinel,
    LoginFlowAction? action,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      selectedRole: selectedRole == _sentinel
          ? this.selectedRole
          : selectedRole as String?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [isLoading, selectedRole, errorMessage, action];
}
