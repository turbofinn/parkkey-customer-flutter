import 'package:json_annotation/json_annotation.dart';

part 'customer_vehicle_details_response.g.dart';

@JsonSerializable()
class CustomerVehicleDetailsResponse {
  @JsonKey(name: 'myVehicleList')
  final List<CustomerVehicleResponse> customerVehicleList;

  CustomerVehicleDetailsResponse(this.customerVehicleList);

  factory CustomerVehicleDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerVehicleDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVehicleDetailsResponseToJson(this);
}

@JsonSerializable()
class CustomerVehicleResponse {
  @JsonKey(name: 'vehicleID')
  final String vehicleID;

  @JsonKey(name: 'vehicleNo')
  final String vehicleNo;

  @JsonKey(name: 'vehicleType')
  final String vehicleType;

  @JsonKey(name: 'parkingLocation')
  final String? parkingLocation;

  @JsonKey(name: 'parkingDateTime')
  final String? parkingDateTime;

  @JsonKey(name: 'parkingDuration')
  final String? parkingDuration;

  @JsonKey(name: 'parkingTicketID')
  final String? parkingTicketID;

  @JsonKey(name: 'customerName')
  final String? customerName;

  CustomerVehicleResponse(
      this.vehicleID,
      this.vehicleNo,
      this.vehicleType, {
        this.parkingLocation,
        this.parkingDateTime,
        this.parkingDuration,
        this.parkingTicketID,
        this.customerName
      });

  factory CustomerVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerVehicleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVehicleResponseToJson(this);
}
