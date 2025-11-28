import 'package:equatable/equatable.dart';
import 'notification_data_model.dart';

class NotificationModel extends Equatable {
  final int id;
  final String type;
  final String title;
  final String body;
  final String? readAt;
  final String createdAt;
  final NotificationDataModel data;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.readAt,
    required this.createdAt,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      data: NotificationDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      if (readAt != null) 'read_at': readAt,
      'created_at': createdAt,
      'data': data.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, type, title, body, readAt, createdAt, data];
}


