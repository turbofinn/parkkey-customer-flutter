// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_vehicle_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteVehicleResponse _$DeleteVehicleResponseFromJson(
        Map<String, dynamic> json) =>
    DeleteVehicleResponse(
      message: json['message'] as String?,
      vehicleNo: json['vehicleNo'] as String?,
      vehicleType: json['vehicleType'] as String?,
    );

Map<String, dynamic> _$DeleteVehicleResponseToJson(
        DeleteVehicleResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
    };
