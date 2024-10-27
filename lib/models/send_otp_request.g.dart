// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpRequest _$SendOtpRequestFromJson(Map<String, dynamic> json) =>
    SendOtpRequest(
      json['mobileNo'] as String,
      json['isWhatsAppAvailable'] as bool,
    );

Map<String, dynamic> _$SendOtpRequestToJson(SendOtpRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
      'isWhatsAppAvailable': instance.isWhatsAppAvailable,
    };
