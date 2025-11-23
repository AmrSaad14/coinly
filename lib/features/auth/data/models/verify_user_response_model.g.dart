// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyUserResponseModel _$VerifyUserResponseModelFromJson(
        Map<String, dynamic> json) =>
    VerifyUserResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$VerifyUserResponseModelToJson(
        VerifyUserResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
