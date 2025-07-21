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
      json['customerName'] as String?,
      json['vehicleType'] as String?,
      json['vehicleNo'] as String?,
      json['parkingStatus'] as String?,
      json['parkingLocation'] as String?,
      json['mobileNo'] as String?,
      json['parkedDuration'] as String?,
      json['parkDate'] as String?,
      json['parkingSpaceNo'] as String?,
      json['parkingTicketID'] as String?,
      json['parkingCharges'] as String?,
      json['entryTime'] as String?,
      json['exitTime'] as String?,
      json['parkingName'] as String?,
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
      'parkDate': instance.parkDate,
      'parkingSpaceNo': instance.parkingSpaceNo,
      'parkingTicketID': instance.parkingTicketID,
      'parkingCharges': instance.parkingCharges,
      'entryTime': instance.entryTime,
      'exitTime': instance.exitTime,
      'parkingName': instance.parkingName,
    };
