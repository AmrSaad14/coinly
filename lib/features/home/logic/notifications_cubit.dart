import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants.dart';
import '../data/repository/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;
  final SharedPreferences sharedPreferences;

  NotificationsCubit({
    required this.repository,
    required this.sharedPreferences,
  }) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());

    final accessToken =
        sharedPreferences.getString(AppConstants.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      emit(const NotificationsError(
          'لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';
    final result = await repository.getNotifications(authorization);

    result.fold(
      (failure) => emit(NotificationsError(_mapFailureToMessage(failure))),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }

  Future<void> markAllNotificationsRead() async {
    final accessToken =
        sharedPreferences.getString(AppConstants.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      emit(const NotificationsError(
          'لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';
    final result = await repository.markAllNotificationsRead(authorization);

    result.fold(
      (failure) => emit(NotificationsError(_mapFailureToMessage(failure))),
      (message) {
        // Show success message if available
        if (message != null && message.isNotEmpty) {
          emit(NotificationsSuccess(message));
        }
        // After marking all as read, reload notifications to update the UI
        loadNotifications();
      },
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

