import 'package:json_annotation/json_annotation.dart';
part 'send_otp_request.g.dart';


@JsonSerializable()
class SendOtpRequest{
  final String mobileNo;
  bool isWhatsAppAvailable;

  SendOtpRequest(this.mobileNo,this.isWhatsAppAvailable);

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) => _$SendOtpRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);

}