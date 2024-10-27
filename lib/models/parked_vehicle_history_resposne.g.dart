// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parked_vehicle_history_resposne.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkedVehicleHistoryResponse _$ParkedVehicleHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    ParkedVehicleHistoryResponse(
      parkedVehicleHistoryList:
          (json['parkedVehicleHistoryList'] as List<dynamic>)
              .map((e) => ParkingResponse.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ParkedVehicleHistoryResponseToJson(
        ParkedVehicleHistoryResponse instance) =>
    <String, dynamic>{
      'parkedVehicleHistoryList': instance.parkedVehicleHistoryList,
    };

ParkingResponse _$ParkingResponseFromJson(Map<String, dynamic> json) =>
    ParkingResponse(
      customerName: json['customerName'] as String,
      vehicleType: json['vehicleType'] as String,
      vehicleNo: json['vehicleNo'] as String,
      parkingStatus: json['parkingStatus'] as String,
      parkingLocation: json['parkingLocation'] as String,
      mobileNo: json['mobileNo'] as String,
      parkedDuration: json['parkedDuration'] as String,
    );

Map<String, dynamic> _$ParkingResponseToJson(ParkingResponse instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'vehicleType': instance.vehicleType,
      'vehicleNo': instance.vehicleNo,
      'parkingStatus': instance.parkingStatus,
      'parkingLocation': instance.parkingLocation,
      'mobileNo': instance.mobileNo,
      'parkedDuration': instance.parkedDuration,
    };
