// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ticket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTicketResponse _$CreateTicketResponseFromJson(
        Map<String, dynamic> json) =>
    CreateTicketResponse(
      parkingTicketID: json['parkingTicketID'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$CreateTicketResponseToJson(
        CreateTicketResponse instance) =>
    <String, dynamic>{
      'parkingTicketID': instance.parkingTicketID,
      'errorMessage': instance.errorMessage,
    };
