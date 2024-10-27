// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_vehicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddVehicleResponse _$AddVehicleResponseFromJson(Map<String, dynamic> json) =>
    AddVehicleResponse(
      json['vehicleID'] as String,
      json['userID'] as String,
      json['vehicleNo'] as String,
      json['createdDate'] as String,
      json['updatedDate'] as String,
    );

Map<String, dynamic> _$AddVehicleResponseToJson(AddVehicleResponse instance) =>
    <String, dynamic>{
      'vehicleID': instance.vehicleID,
      'userID': instance.userID,
      'vehicleNo': instance.vehicleNo,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
