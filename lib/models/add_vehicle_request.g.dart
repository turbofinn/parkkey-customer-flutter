// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_vehicle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddVehicleRequest _$AddVehicleRequestFromJson(Map<String, dynamic> json) =>
    AddVehicleRequest(
      json['userID'] as String,
      json['vehicleNo'] as String,
      json['vehicleType'] as String,
    );

Map<String, dynamic> _$AddVehicleRequestToJson(AddVehicleRequest instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
    };
