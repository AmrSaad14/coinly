import 'package:json_annotation/json_annotation.dart';

part 'transaction_request_model.g.dart';

@JsonSerializable()
class TransactionRequestModel {
  @JsonKey(name: 'transaction')
  final TransactionBody transaction;

  TransactionRequestModel({
    required this.transaction,
  });

  factory TransactionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRequestModelToJson(this);
}

@JsonSerializable()
class TransactionBody {
  @JsonKey(name: 'client_phone_number')
  final String clientPhoneNumber;

  @JsonKey(name: 'market_id')
  final int marketId;

  @JsonKey(name: 'points_total')
  final int pointsTotal;

  TransactionBody({
    required this.clientPhoneNumber,
    required this.marketId,
    required this.pointsTotal,
  });

  factory TransactionBody.fromJson(Map<String, dynamic> json) =>
      _$TransactionBodyFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionBodyToJson(this);
}
