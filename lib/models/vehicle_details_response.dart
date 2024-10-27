import 'package:json_annotation/json_annotation.dart';
part 'vehicle_details_response.g.dart';

@JsonSerializable()
class VehicleDetailsResponse {
  @JsonKey(name: 'userID')
  final String userID;

  @JsonKey(name: 'vehicleID')
  final String vehicleID;

  @JsonKey(name: 'vehicleNo')
  final String vehicleNo;

  @JsonKey(name: 'customerName')
  final String? customerName;

  @JsonKey(name: 'parkingTicketID')
  final String parkingTicketID;

  @JsonKey(name: 'totalParkingCharges')
  final String parkingCharges;


  VehicleDetailsResponse(this.userID, this.vehicleID, this.vehicleNo, this.parkingTicketID, this.parkingCharges, {this.customerName});

  factory VehicleDetailsResponse.fromJson(Map<String, dynamic> json) => _$VehicleDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDetailsResponseToJson(this);
}
