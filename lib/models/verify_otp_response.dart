import 'package:json_annotation/json_annotation.dart';
import 'package:parkey_customer/models/user.dart';
import 'status.dart';
part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOtpResponse{

  @JsonKey(name: 'status')
  Status? status;
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'token')
  String? token;
  @JsonKey(name: 'refreshToken')
  String? refreshToken;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'defaultVehicleNo')
  String? defaultVehicleNo;


  VerifyOtpResponse(
      {this.status, this.user, this.token, this.refreshToken, this.message, this.defaultVehicleNo});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);

}