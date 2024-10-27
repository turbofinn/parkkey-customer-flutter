// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_space_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkingSpaceInfoResponse _$ParkingSpaceInfoResponseFromJson(
        Map<String, dynamic> json) =>
    ParkingSpaceInfoResponse(
      json['parkingSpaceID'] as String,
      (json['vehicleType'] as List<dynamic>).map((e) => e as String).toList(),
      json['vendorID'] as String,
      (json['availableSpace'] as num).toInt(),
      (json['totalSpace'] as num).toInt(),
      (json['rating'] as num).toInt(),
      json['parkingName'] as String,
      json['review'] as String,
      json['location'] as String,
      json['parkingSpaceStatus'] as String,
      json['createdDate'] as String,
      json['updatedDate'] as String,
    );

Map<String, dynamic> _$ParkingSpaceInfoResponseToJson(
        ParkingSpaceInfoResponse instance) =>
    <String, dynamic>{
      'parkingSpaceID': instance.parkingSpaceID,
      'vehicleType': instance.vehicleType,
      'vendorID': instance.vendorID,
      'availableSpace': instance.availableSpace,
      'totalSpace': instance.totalSpace,
      'rating': instance.rating,
      'parkingName': instance.parkingName,
      'review': instance.review,
      'location': instance.location,
      'parkingSpaceStatus': instance.parkingSpaceStatus,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
