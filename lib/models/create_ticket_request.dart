
import 'package:json_annotation/json_annotation.dart';
part 'create_ticket_request.g.dart';

@JsonSerializable()
class CreateTicketRequest{
  final String userID;
  final String vehicleID;
  final String requestType;


  CreateTicketRequest(this.userID, this.vehicleID, this.requestType);

  factory CreateTicketRequest.fromJson(Map<String, dynamic> json) => _$CreateTicketRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTicketRequestToJson(this);

}