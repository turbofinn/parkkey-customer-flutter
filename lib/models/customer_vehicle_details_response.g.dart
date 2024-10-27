// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_vehicle_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerVehicleDetailsResponse _$CustomerVehicleDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerVehicleDetailsResponse(
      (json['myVehicleList'] as List<dynamic>)
          .map((e) =>
              CustomerVehicleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerVehicleDetailsResponseToJson(
        CustomerVehicleDetailsResponse instance) =>
    <String, dynamic>{
      'myVehicleList': instance.customerVehicleList,
    };

CustomerVehicleResponse _$CustomerVehicleResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerVehicleResponse(
      json['vehicleID'] as String,
      json['vehicleNo'] as String,
      json['vehicleType'] as String,
      parkingLocation: json['parkingLocation'] as String?,
      parkingDateTime: json['parkingDateTime'] as String?,
      parkingDuration: json['parkingDuration'] as String?,
      parkingTicketID: json['parkingTicketID'] as String?,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$CustomerVehicleResponseToJson(
        CustomerVehicleResponse instance) =>
    <String, dynamic>{
      'vehicleID': instance.vehicleID,
      'vehicleNo': instance.vehicleNo,
      'vehicleType': instance.vehicleType,
      'parkingLocation': instance.parkingLocation,
      'parkingDateTime': instance.parkingDateTime,
      'parkingDuration': instance.parkingDuration,
      'parkingTicketID': instance.parkingTicketID,
      'customerName': instance.customerName,
    };
