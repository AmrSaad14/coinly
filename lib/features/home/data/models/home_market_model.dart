import 'package:equatable/equatable.dart';

class HomeMarketModel extends Equatable {
  final int id;
  final String name;
  final int marketPoints;
  final int marketLoans;

  const HomeMarketModel({
    required this.id,
    required this.name,
    this.marketPoints = 0,
    this.marketLoans = 0,
  });

  factory HomeMarketModel.fromJson(Map<String, dynamic> json) {
    return HomeMarketModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      marketPoints: (json['market_points'] as num?)?.toInt() ?? 0,
      marketLoans: (json['market_loans'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'market_points': marketPoints,
      'market_loans': marketLoans,
    };
  }

  @override
  List<Object> get props => [id, name, marketPoints, marketLoans];
}

