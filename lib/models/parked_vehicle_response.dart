import 'package:json_annotation/json_annotation.dart';

part 'parked_vehicle_response.g.dart';

@JsonSerializable()
class ParkedVehicleResponse {
  @JsonKey(name: 'parkedVehicleHistoryList')
  final List<CustomerVehicleResponse> customerVehicleList;

  ParkedVehicleResponse(this.customerVehicleList);

  factory ParkedVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$ParkedVehicleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkedVehicleResponseToJson(this);
}

@JsonSerializable()
class CustomerVehicleResponse {
  @JsonKey(name: 'vehicleID')
  final String? vehicleID;

  @JsonKey(name: 'vehicleNo')
  final String vehicleNo;

  @JsonKey(name: 'vehicleType')
  final String vehicleType;

  @JsonKey(name: 'parkingLocation')
  final String? parkingLocation;

  @JsonKey(name: 'parkedDuration')
  final String? parkedDuration;

  @JsonKey(name: 'parkingTicketID')
  final String? parkingTicketID;

  @JsonKey(name: 'customerName')
  final String? customerName;

  @JsonKey(name: 'parkingStatus')
  final String? parkingStatus;

  @JsonKey(name: 'mobileNo')
  final String? mobileNo;

  @JsonKey(name: 'parkDate')
  final String? parkDate;

  @JsonKey(name: 'parkingCharges')
  final String? parkingCharges;

  CustomerVehicleResponse(
      this.vehicleNo,
      this.vehicleType, {
        this.parkingLocation,
        this.parkedDuration,
        this.parkingTicketID,
        this.customerName,
        this.parkingStatus,
        this.mobileNo,
        this.parkDate,
        this.parkingCharges,
        this.vehicleID,
      });

  factory CustomerVehicleResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerVehicleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerVehicleResponseToJson(this);
}
