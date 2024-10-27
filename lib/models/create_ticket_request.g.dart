// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ticket_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTicketRequest _$CreateTicketRequestFromJson(Map<String, dynamic> json) =>
    CreateTicketRequest(
      json['userID'] as String,
      json['vehicleID'] as String,
      json['requestType'] as String,
    );

Map<String, dynamic> _$CreateTicketRequestToJson(
        CreateTicketRequest instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'vehicleID': instance.vehicleID,
      'requestType': instance.requestType,
    };
