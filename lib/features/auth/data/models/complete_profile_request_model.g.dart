// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_profile_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteProfileRequestModel _$CompleteProfileRequestModelFromJson(
        Map<String, dynamic> json) =>
    CompleteProfileRequestModel(
      firebaseUid: json['firebase_uid'] as String,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompleteProfileRequestModelToJson(
        CompleteProfileRequestModel instance) =>
    <String, dynamic>{
      'firebase_uid': instance.firebaseUid,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'user': instance.user.toJson(),
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      job: json['job'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'full_name': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'job': instance.job,
    };
