import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_response_model.g.dart';

@JsonSerializable()
class WithdrawalResponseModel {
  final String message;
  final bool success;
  
  @JsonKey(name: 'data')
  final Map<String, dynamic>? data;

  WithdrawalResponseModel({
    required this.message,
    required this.success,
    this.data,
  });

  factory WithdrawalResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalResponseModelToJson(this);
}


