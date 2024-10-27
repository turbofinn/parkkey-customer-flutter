
import 'package:json_annotation/json_annotation.dart';
part 'add_vehicle_request.g.dart';

@JsonSerializable()
class AddVehicleRequest{
  final String userID;
  final String vehicleNo;
  final String vehicleType;


  AddVehicleRequest(this.userID, this.vehicleNo, this.vehicleType);

  factory AddVehicleRequest.fromJson(Map<String, dynamic> json) => _$AddVehicleRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddVehicleRequestToJson(this);

}