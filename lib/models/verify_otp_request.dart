
import 'package:json_annotation/json_annotation.dart';
part 'verify_otp_request.g.dart';

@JsonSerializable()
class VerifyOtpRequest{
  final String mobileNo;
  final String otp;

  VerifyOtpRequest(this.mobileNo, this.otp);

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => _$VerifyOtpRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);

}