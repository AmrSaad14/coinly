// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) =>
    LoginRequestModel(
      grantType: json['grant_type'] as String,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      scope: json['scope'] as String,
    );

Map<String, dynamic> _$LoginRequestModelToJson(LoginRequestModel instance) =>
    <String, dynamic>{
      'grant_type': instance.grantType,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'username': instance.username,
      'password': instance.password,
      'scope': instance.scope,
    };
