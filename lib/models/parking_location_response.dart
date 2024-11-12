import 'package:json_annotation/json_annotation.dart';
part 'parking_location_response.g.dart';

@JsonSerializable()
class ParkingLocationResponse {
  @JsonKey(name: 'parkingSpaceID')
  final String? parkingSpaceID;

  @JsonKey(name: 'parkingSpaceName')
  final String? parkingSpaceName;

  @JsonKey(name: 'latitude')
  final String? latitude;

  @JsonKey(name: 'longitude')
  final String? longitude;

  @JsonKey(name: 'location')
  final String? location;

  @JsonKey(name: 'parkingSpaceStatus')
  final String? parkingSpaceStatus;

  @JsonKey(name: 'address')
  final String? address;


  ParkingLocationResponse(
      {this.parkingSpaceID,
      this.parkingSpaceName,
      this.latitude,
      this.longitude,
      this.location,
      this.parkingSpaceStatus,
      this.address});

  factory ParkingLocationResponse.fromJson(Map<String, dynamic> json) => _$ParkingLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingLocationResponseToJson(this);
}
