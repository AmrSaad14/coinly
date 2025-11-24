import 'package:equatable/equatable.dart';
import 'owner_data_model.dart';

class OwnerResponseModel extends Equatable {
  final OwnerDataModel data;

  const OwnerResponseModel({required this.data});

  factory OwnerResponseModel.fromJson(Map<String, dynamic> json) {
    return OwnerResponseModel(
      data: OwnerDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }

  @override
  List<Object> get props => [data];
}

