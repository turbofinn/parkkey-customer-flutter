// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_location_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingLocationResponse _$ParkingLocationResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingLocationResponse(
      parkingSpaceID: json['parkingSpaceID'] as String?,
      parkingSpaceName: json['parkingSpaceName'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      location: json['location'] as String?,
      parkingSpaceStatus: json['parkingSpaceStatus'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ParkingLocationResponseToJson(
        ParkingLocationResponse instance) =>
    <String, dynamic>{
      'parkingSpaceID': instance.parkingSpaceID,
      'parkingSpaceName': instance.parkingSpaceName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location': instance.location,
      'parkingSpaceStatus': instance.parkingSpaceStatus,
      'address': instance.address,
    };
