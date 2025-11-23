// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyUserRequestModel _$VerifyUserRequestModelFromJson(
        Map<String, dynamic> json) =>
    VerifyUserRequestModel(
      idToken: json['id_token'] as String,
      phoneNumber: json['phone_number'] as String,
      firebaseUid: json['firebase_uid'] as String,
    );

Map<String, dynamic> _$VerifyUserRequestModelToJson(
        VerifyUserRequestModel instance) =>
    <String, dynamic>{
      'id_token': instance.idToken,
      'phone_number': instance.phoneNumber,
      'firebase_uid': instance.firebaseUid,
    };
