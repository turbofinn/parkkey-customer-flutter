// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerDetailsResponse _$CustomerDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerDetailsResponse(
      customerName: json['customerName'] as String?,
      mobileNo: json['mobileNo'] as String?,
      gender: json['gender'] as String?,
      primaryVehicle: json['primaryVehicle'] as String?,
      emailID: json['emailID'] as String?,
    );

Map<String, dynamic> _$CustomerDetailsResponseToJson(
        CustomerDetailsResponse instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'mobileNo': instance.mobileNo,
      'gender': instance.gender,
      'primaryVehicle': instance.primaryVehicle,
      'emailID': instance.emailID,
    };
