import 'package:json_annotation/json_annotation.dart';

part 'transaction_response_model.g.dart';

@JsonSerializable()
class TransactionResponseModel {
  final String message;

  @JsonKey(name: 'transaction')
  final Map<String, dynamic>? transaction;

  @JsonKey(name: 'worker_new_balance')
  final int? workerNewBalance;

  TransactionResponseModel({
    required this.message,
    this.transaction,
    this.workerNewBalance,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseModelToJson(this);
}

