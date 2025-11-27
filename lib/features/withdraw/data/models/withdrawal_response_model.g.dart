// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalResponseModel _$WithdrawalResponseModelFromJson(
        Map<String, dynamic> json) =>
    WithdrawalResponseModel(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WithdrawalResponseModelToJson(
        WithdrawalResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };
