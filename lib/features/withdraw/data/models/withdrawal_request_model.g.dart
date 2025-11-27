// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawalRequestModel _$WithdrawalRequestModelFromJson(
        Map<String, dynamic> json) =>
    WithdrawalRequestModel(
      withdrawalRequest: WithdrawalRequest.fromJson(
          json['withdrawal_request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WithdrawalRequestModelToJson(
        WithdrawalRequestModel instance) =>
    <String, dynamic>{
      'withdrawal_request': instance.withdrawalRequest,
    };

WithdrawalRequest _$WithdrawalRequestFromJson(Map<String, dynamic> json) =>
    WithdrawalRequest(
      points: (json['points'] as num).toInt(),
      method: json['method'] as String,
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$WithdrawalRequestToJson(WithdrawalRequest instance) =>
    <String, dynamic>{
      'points': instance.points,
      'method': instance.method,
      'phone_number': instance.phoneNumber,
    };
