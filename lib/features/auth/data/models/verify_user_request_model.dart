import 'package:json_annotation/json_annotation.dart';

part 'verify_user_request_model.g.dart';

@JsonSerializable()
class VerifyUserRequestModel {
  @JsonKey(name: 'id_token')
  final String idToken;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @JsonKey(name: 'firebase_uid')
  final String firebaseUid;

  VerifyUserRequestModel({
    required this.idToken,
    required this.phoneNumber,
    required this.firebaseUid,
  });

  factory VerifyUserRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyUserRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyUserRequestModelToJson(this);
}
