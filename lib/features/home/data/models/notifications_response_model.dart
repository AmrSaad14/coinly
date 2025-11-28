import 'package:equatable/equatable.dart';
import 'notification_model.dart';

class NotificationsResponseModel extends Equatable {
  final List<NotificationModel> notifications;

  const NotificationsResponseModel({
    required this.notifications,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((item) =>
                  NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((n) => n.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [notifications];
}


