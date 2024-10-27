
import 'package:json_annotation/json_annotation.dart';
part 'add_vehicle_response.g.dart';

@JsonSerializable()
class AddVehicleResponse{
  final String vehicleID;
  final String userID;
  final String vehicleNo;
  final String createdDate;
  final String updatedDate;


  AddVehicleResponse(this.vehicleID, this.userID, this.vehicleNo,
      this.createdDate, this.updatedDate);

  factory AddVehicleResponse.fromJson(Map<String, dynamic> json) => _$AddVehicleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AddVehicleResponseToJson(this);

}