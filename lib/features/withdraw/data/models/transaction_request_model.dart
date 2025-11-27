import 'package:json_annotation/json_annotation.dart';

part 'transaction_request_model.g.dart';

@JsonSerializable()
class TransactionRequestModel {
  final int points;
  
  @JsonKey(name: 'kiosk_number')
  final String kioskNumber;
  
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;

  TransactionRequestModel({
    required this.points,
    required this.kioskNumber,
    this.paymentMethod,
  });

  factory TransactionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRequestModelToJson(this);
}


