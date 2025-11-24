import 'package:json_annotation/json_annotation.dart';

part 'complete_profile_request_model.g.dart';

@JsonSerializable()
class CompleteProfileRequestModel {
  @JsonKey(name: 'firebase_uid')
  final String firebaseUid;

  @JsonKey(name: 'client_id')
  final String clientId;

  @JsonKey(name: 'client_secret')
  final String clientSecret;

  final UserData user;

  CompleteProfileRequestModel({
    required this.firebaseUid,
    required this.clientId,
    required this.clientSecret,
    required this.user,
  });

  factory CompleteProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteProfileRequestModelToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: 'full_name')
  final String fullName;

  final String email;
  final String password;
  final String job;

  UserData({
    required this.fullName,
    required this.email,
    required this.password,
    required this.job,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}




