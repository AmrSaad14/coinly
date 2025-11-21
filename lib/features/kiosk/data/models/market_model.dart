import 'package:equatable/equatable.dart';

class MarketModel extends Equatable {
  final String name;
  final String kind;
  final String location;

  const MarketModel({
    required this.name,
    required this.kind,
    required this.location,
  });

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      name: json['name'] as String,
      kind: json['kind'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'kind': kind, 'location': location};
  }

  @override
  List<Object> get props => [name, kind, location];
}
