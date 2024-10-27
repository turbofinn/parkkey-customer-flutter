import 'package:json_annotation/json_annotation.dart';
part 'send_otp_response.g.dart';

@JsonSerializable()
class SendOtpResponse{
 final String message;

 SendOtpResponse(this.message);

 factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
     _$SendOtpResponseFromJson(json);

 Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);


}