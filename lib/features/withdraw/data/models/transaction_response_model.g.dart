// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponseModel _$TransactionResponseModelFromJson(
        Map<String, dynamic> json) =>
    TransactionResponseModel(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TransactionResponseModelToJson(
        TransactionResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };
