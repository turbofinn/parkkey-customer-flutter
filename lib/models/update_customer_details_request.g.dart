// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_customer_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCustomerDetailsRequest _$UpdateCustomerDetailsRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateCustomerDetailsRequest(
      json['source'] as String,
      json['userID'] as String,
      json['gender'] as String,
      json['emailID'] as String,
      json['primaryVehicle'] as String,
      json['customerName'] as String,
    );

Map<String, dynamic> _$UpdateCustomerDetailsRequestToJson(
        UpdateCustomerDetailsRequest instance) =>
    <String, dynamic>{
      'source': instance.source,
      'userID': instance.userID,
      'gender': instance.gender,
      'emailID': instance.emailID,
      'primaryVehicle': instance.primaryVehicle,
      'customerName': instance.customerName,
    };
