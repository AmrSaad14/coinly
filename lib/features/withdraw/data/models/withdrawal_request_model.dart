import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_request_model.g.dart';

@JsonSerializable()
class WithdrawalRequestModel {
  @JsonKey(name: 'withdrawal_request')
  final WithdrawalRequest withdrawalRequest;

  WithdrawalRequestModel({required this.withdrawalRequest});

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalRequestModelToJson(this);
}

@JsonSerializable()
class WithdrawalRequest {
  final int points;

  final String method;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  WithdrawalRequest({
    required this.points,
    required this.method,
    required this.phoneNumber,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalRequestToJson(this);
}
