// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRequestModel _$TransactionRequestModelFromJson(
        Map<String, dynamic> json) =>
    TransactionRequestModel(
      transaction:
          TransactionBody.fromJson(json['transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionRequestModelToJson(
        TransactionRequestModel instance) =>
    <String, dynamic>{
      'transaction': instance.transaction.toJson(),
    };

TransactionBody _$TransactionBodyFromJson(Map<String, dynamic> json) =>
    TransactionBody(
      clientPhoneNumber: json['client_phone_number'] as String,
      marketId: (json['market_id'] as num).toInt(),
      pointsTotal: (json['points_total'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionBodyToJson(TransactionBody instance) =>
    <String, dynamic>{
      'client_phone_number': instance.clientPhoneNumber,
      'market_id': instance.marketId,
      'points_total': instance.pointsTotal,
    };
