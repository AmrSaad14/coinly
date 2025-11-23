import 'package:equatable/equatable.dart';

class MarketModel extends Equatable {
  final int id;
  final String name;
  final String kind;
  final String location;

  const MarketModel({
    required this.id,
    required this.name,
    required this.kind,
    required this.location,
  });

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      id: json['id'] as int,
      name: json['name'] as String,
      kind: json['kind'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kind': kind,
      'location': location,
    };
  }

  @override
  List<Object> get props => [id, name, kind, location];
}
