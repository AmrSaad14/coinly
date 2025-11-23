import 'package:json_annotation/json_annotation.dart';

part 'verify_user_response_model.g.dart';

@JsonSerializable()
class VerifyUserResponseModel {
  @JsonKey(defaultValue: false)
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  VerifyUserResponseModel({required this.success, this.message, this.data});

  factory VerifyUserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyUserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyUserResponseModelToJson(this);
}
