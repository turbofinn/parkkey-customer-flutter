import 'package:json_annotation/json_annotation.dart';
part 'delete_vehicle_response.g.dart';

@JsonSerializable()
class DeleteVehicleResponse{
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'vehicleNo')
  String? vehicleNo;
  @JsonKey(name: 'vehicleType')
  String? vehicleType;


  DeleteVehicleResponse({this.message, this.vehicleNo, this.vehicleType});

  factory DeleteVehicleResponse.fromJson(Map<String, dynamic> json) => _$DeleteVehicleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteVehicleResponseToJson(this);

}