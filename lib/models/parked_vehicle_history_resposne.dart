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
  final String customerName;

  @JsonKey(name: 'vehicleType')
  final String vehicleType;

  @JsonKey(name: 'vehicleNo')
  final String vehicleNo;

  @JsonKey(name: 'parkingStatus')
  final String parkingStatus;

  @JsonKey(name: 'parkingLocation')
  final String parkingLocation;

  @JsonKey(name: 'mobileNo')
  final String mobileNo;

  @JsonKey(name: 'parkedDuration')
  final String parkedDuration;

  ParkingResponse({
    required this.customerName,
    required this.vehicleType,
    required this.vehicleNo,
    required this.parkingStatus,
    required this.parkingLocation,
    required this.mobileNo,
    required this.parkedDuration,
  });

  factory ParkingResponse.fromJson(Map<String, dynamic> json) => _$ParkingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingResponseToJson(this);
}
