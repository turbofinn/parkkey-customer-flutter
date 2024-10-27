import 'package:json_annotation/json_annotation.dart';
part 'parking_location_response.g.dart';

@JsonSerializable()
class ParkingLocationResponse {
  @JsonKey(name: 'parkingSpaceID')
  final String parkingSpaceID;

  @JsonKey(name: 'parkingSpaceName')
  final String parkingSpaceName;

  @JsonKey(name: 'latitude')
  final String latitude;

  @JsonKey(name: 'longitude')
  final String longitude;


  ParkingLocationResponse(this.parkingSpaceID, this.parkingSpaceName,
      this.latitude, this.longitude);

  factory ParkingLocationResponse.fromJson(Map<String, dynamic> json) => _$ParkingLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingLocationResponseToJson(this);
}
