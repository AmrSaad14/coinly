import 'package:equatable/equatable.dart';
import 'home_market_model.dart';

class OwnerDataModel extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? job;
  final String role;
  final bool isVerified;
  final String phoneNumber;
  final int points;
  final int loans;
  final int profits;
  final int workersCount;
  final List<HomeMarketModel> markets;

  const OwnerDataModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.job,
    required this.role,
    this.isVerified = false,
    required this.phoneNumber,
    this.points = 0,
    this.loans = 0,
    this.profits = 0,
    this.workersCount = 0,
    this.markets = const [],
  });

  factory OwnerDataModel.fromJson(Map<String, dynamic> json) {
    return OwnerDataModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      job: json['job'] as String?,
      role: json['role'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      phoneNumber: json['phone_number'] as String? ?? '',
      points: (json['points'] as num?)?.toInt() ?? 0,
      loans: (json['loans'] as num?)?.toInt() ?? 0,
      profits: (json['profits'] as num?)?.toInt() ?? 0,
      workersCount: (json['workers_count'] as num?)?.toInt() ?? 0,
      markets:
          (json['markets'] as List<dynamic>?)
              ?.map(
                (item) =>
                    HomeMarketModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      if (job != null) 'job': job,
      'role': role,
      'is_verified': isVerified,
      'phone_number': phoneNumber,
      'points': points,
      'loans': loans,
      'profits': profits,
      'workers_count': workersCount,
      'markets': markets.map((market) => market.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    job,
    role,
    isVerified,
    phoneNumber,
    points,
    loans,
    profits,
    workersCount,
    markets,
  ];
}
