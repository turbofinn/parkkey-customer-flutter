// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDetailsResponse _$VehicleDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    VehicleDetailsResponse(
      json['userID'] as String,
      json['vehicleID'] as String,
      json['vehicleNo'] as String,
      json['parkingTicketID'] as String,
      json['totalParkingCharges'] as String,
      customerName: json['customerName'] as String?,
    );

Map<String, dynamic> _$VehicleDetailsResponseToJson(
        VehicleDetailsResponse instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'vehicleID': instance.vehicleID,
      'vehicleNo': instance.vehicleNo,
      'customerName': instance.customerName,
      'parkingTicketID': instance.parkingTicketID,
      'totalParkingCharges': instance.parkingCharges,
    };
