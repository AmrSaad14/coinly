// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalResponseModel _$WithdrawalResponseModelFromJson(
        Map<String, dynamic> json) =>
    WithdrawalResponseModel(
      message: json['message'] as String,
      withdrawal: json['withdrawal'] as Map<String, dynamic>?,
      remainingBalance: (json['remaining_balance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WithdrawalResponseModelToJson(
        WithdrawalResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'withdrawal': instance.withdrawal,
      'remaining_balance': instance.remainingBalance,
    };
