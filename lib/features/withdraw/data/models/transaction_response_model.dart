import 'package:json_annotation/json_annotation.dart';

part 'transaction_response_model.g.dart';

@JsonSerializable()
class TransactionResponseModel {
  final String message;
  final bool success;
  
  @JsonKey(name: 'data')
  final Map<String, dynamic>? data;

  TransactionResponseModel({
    required this.message,
    required this.success,
    this.data,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseModelToJson(this);
}


