// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parked_vehicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkedVehicleResponse _$ParkedVehicleResponseFromJson(
        Map<String, dynamic> json) =>
    ParkedVehicleResponse(
      (json['parkedVehicleHistoryList'] as List<dynamic>)
          .map((e) =>
              CustomerVehicleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ParkedVehicleResponseToJson(
        ParkedVehicleResponse instance) =>
    <String, dynamic>{
      'parkedVehicleHistoryList': instance.customerVehicleList,
    };

CustomerVehicleResponse _$CustomerVehicleResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerVehicleResponse(
      json['vehicleNo'] as String,
      json['vehicleType'] as String,
      parkingLocation: json['parkingLocation'] as String?,
      parkedDuration: json['parkedDuration'] as String?,
      parkingTicketID: json['parkingTicketID'] as String?,
      customerName: json['customerName'] as String?,
      parkingStatus: json['parkingStatus'] as String?,
      mobileNo: json['mobileNo'] as String?,
      parkDate: json['parkDate'] as String?,
      parkingCharges: json['parkingCharges'] as String?,
      vehicleID: json['vehicleID'] as String?,
    );

Map<String, dynamic> _$CustomerVehicleResponseToJson(
        CustomerVehicleResponse instance) =>
    <String, dynamic>{
      'vehicleID': instance.vehicleID,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
      'parkingLocation': instance.parkingLocation,
      'parkedDuration': instance.parkedDuration,
      'parkingTicketID': instance.parkingTicketID,
      'customerName': instance.customerName,
      'parkingStatus': instance.parkingStatus,
      'mobileNo': instance.mobileNo,
      'parkDate': instance.parkDate,
      'parkingCharges': instance.parkingCharges,
    };
