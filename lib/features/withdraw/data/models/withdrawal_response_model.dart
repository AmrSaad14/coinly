import 'package:json_annotation/json_annotation.dart';

part 'withdrawal_response_model.g.dart';

@JsonSerializable()
class WithdrawalResponseModel {
  final String message;
  @JsonKey(name: 'withdrawal')
  final Map<String, dynamic>? withdrawal;

  @JsonKey(name: 'remaining_balance')
  final int? remainingBalance;

  WithdrawalResponseModel({
    required this.message,
    this.withdrawal,
    this.remainingBalance,
  });

  factory WithdrawalResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalResponseModelToJson(this);
}



