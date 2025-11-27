// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRequestModel _$TransactionRequestModelFromJson(
        Map<String, dynamic> json) =>
    TransactionRequestModel(
      points: (json['points'] as num).toInt(),
      kioskNumber: json['kiosk_number'] as String,
      paymentMethod: json['payment_method'] as String?,
    );

Map<String, dynamic> _$TransactionRequestModelToJson(
        TransactionRequestModel instance) =>
    <String, dynamic>{
      'points': instance.points,
      'kiosk_number': instance.kioskNumber,
      'payment_method': instance.paymentMethod,
    };
