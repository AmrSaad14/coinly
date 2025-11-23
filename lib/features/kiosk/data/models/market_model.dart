import 'package:equatable/equatable.dart';

class MarketModel extends Equatable {
  final int id;
  final String name;
  final int marketPoints;
  final int marketLoans;
  final String? kind;
  final String? location;

  const MarketModel({
    required this.id,
    required this.name,
    this.marketPoints = 0,
    this.marketLoans = 0,
    this.kind,
    this.location,
  });

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      marketPoints: (json['market_points'] as num?)?.toInt() ?? 0,
      marketLoans: (json['market_loans'] as num?)?.toInt() ?? 0,
      kind: json['kind'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (marketPoints > 0 || marketLoans > 0) {
      map['market_points'] = marketPoints;
      map['market_loans'] = marketLoans;
    }
    if (kind != null) map['kind'] = kind;
    if (location != null) map['location'] = location;
    return map;
  }

  @override
  List<Object?> get props => [id, name, marketPoints, marketLoans, kind, location];
}
