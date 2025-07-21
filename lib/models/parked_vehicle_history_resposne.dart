import 'package:json_annotation/json_annotation.dart';
part 'parked_vehicle_history_resposne.g.dart';

@JsonSerializable()
class ParkedVehicleHistoryResponse {
  @JsonKey(name: 'parkedVehicleHistoryList')
  final List<ParkingResponse> parkedVehicleHistoryList;

  ParkedVehicleHistoryResponse({required this.parkedVehicleHistoryList});

  factory ParkedVehicleHistoryResponse.fromJson(Map<String, dynamic> json) => _$ParkedVehicleHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkedVehicleHistoryResponseToJson(this);
}

@JsonSerializable()
class ParkingResponse {
  @JsonKey(name: 'customerName')
  final String? customerName;

  @JsonKey(name: 'vehicleType')
  final String? vehicleType;

  @JsonKey(name: 'vehicleNo')
  final String? vehicleNo;

  @JsonKey(name: 'parkingStatus')
  final String? parkingStatus;

  @JsonKey(name: 'parkingLocation')
  final String? parkingLocation;

  @JsonKey(name: 'mobileNo')
  final String? mobileNo;

  @JsonKey(name: 'parkedDuration')
  final String? parkedDuration;

  @JsonKey(name: 'parkDate')
  final String? parkDate;

  @JsonKey(name: 'parkingSpaceNo')
  final String? parkingSpaceNo;

  @JsonKey(name: 'parkingTicketID')
  final String? parkingTicketID;

  @JsonKey(name: 'parkingCharges')
  final String? parkingCharges;

  @JsonKey(name: 'entryTime')
  final String? entryTime;

  @JsonKey(name: 'exitTime')
  final String? exitTime;

  @JsonKey(name: 'parkingName')
  final String? parkingName;

  ParkingResponse(
      this.customerName,
      this.vehicleType,
      this.vehicleNo,
      this.parkingStatus,
      this.parkingLocation,
      this.mobileNo,
      this.parkedDuration,
      this.parkDate,
      this.parkingSpaceNo,
      this.parkingTicketID,
      this.parkingCharges,
      this.entryTime,
      this.exitTime,
      this.parkingName,
      );

  factory ParkingResponse.fromJson(Map<String, dynamic> json) => _$ParkingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingResponseToJson(this);
}
