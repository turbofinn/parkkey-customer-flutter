// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_ticket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTicketResponse _$GetTicketResponseFromJson(Map<String, dynamic> json) =>
    GetTicketResponse(
      parkingTicketID: json['parkingTicketID'] as String,
      vehicleNo: json['vehicleNo'] as String,
      vehicleType: json['vehicleType'] as String,
      parkingStatus: json['parkingStatus'] as String,
      mobileNo: json['mobileNo'] as String,
      parkingLocation: json['parkingLocation'] as String?,
      parkedDuration: json['parkedDuration'] as String?,
      parkDate: json['parkDate'] as String?,
      exitOTP: json['exitOTP'] as String?,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$GetTicketResponseToJson(GetTicketResponse instance) =>
    <String, dynamic>{
      'parkingTicketID': instance.parkingTicketID,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
      'parkingStatus': instance.parkingStatus,
      'mobileNo': instance.mobileNo,
      'parkingLocation': instance.parkingLocation,
      'parkedDuration': instance.parkedDuration,
      'parkDate': instance.parkDate,
      'exitOTP': instance.exitOTP,
      'customerName': instance.customerName,
    };
