import 'package:equatable/equatable.dart';

class NotificationDataModel extends Equatable {
  final String clientPhone;
  final int totalPoints;

  const NotificationDataModel({
    required this.clientPhone,
    required this.totalPoints,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      clientPhone: json['client_phone'] as String? ?? '',
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_phone': clientPhone,
      'total_points': totalPoints,
    };
  }

  @override
  List<Object?> get props => [clientPhone, totalPoints];
}


