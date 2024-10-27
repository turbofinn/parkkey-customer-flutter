// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingLocationResponse _$ParkingLocationResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingLocationResponse(
      json['parkingSpaceID'] as String,
      json['parkingSpaceName'] as String,
      json['latitude'] as String,
      json['longitude'] as String,
    );

Map<String, dynamic> _$ParkingLocationResponseToJson(
        ParkingLocationResponse instance) =>
    <String, dynamic>{
      'parkingSpaceID': instance.parkingSpaceID,
      'parkingSpaceName': instance.parkingSpaceName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
