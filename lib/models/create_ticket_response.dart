import 'package:json_annotation/json_annotation.dart';
part 'create_ticket_response.g.dart';

@JsonSerializable()
class CreateTicketResponse{
  final String? parkingTicketID;
  final String? errorMessage;


  CreateTicketResponse({this.parkingTicketID, this.errorMessage});

  factory CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('parkingTicketID')) {
      return CreateTicketResponse(parkingTicketID: json['parkingTicketID']);
    } else if (json.containsKey('errorMessage')) {
      return CreateTicketResponse(errorMessage: json['errorMessage']);
    } else {
      throw ArgumentError('Invalid JSON for CreateTicketResponse');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (parkingTicketID != null) {
      data['parkingTicketID'] = parkingTicketID;
    }
    if (errorMessage != null) {
      data['errorMessage'] = errorMessage;
    }
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }

}