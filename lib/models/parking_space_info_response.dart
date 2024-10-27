import 'package:json_annotation/json_annotation.dart';
part 'parking_space_info_response.g.dart';

@JsonSerializable()
class ParkingSpaceInfoResponse {
  @JsonKey(name: 'parkingSpaceID')
  final String parkingSpaceID;

  @JsonKey(name: 'vehicleType')
  final List<String> vehicleType;

  @JsonKey(name: 'vendorID')
  final String vendorID;

  @JsonKey(name: 'availableSpace')
  final int availableSpace;

  @JsonKey(name: 'totalSpace')
  final int totalSpace;

  @JsonKey(name: 'rating')
  final int rating;

  @JsonKey(name: 'parkingName')
  final String parkingName;

  @JsonKey(name: 'review')
  final String review;

  @JsonKey(name: 'location')
  final String location;

  @JsonKey(name: 'parkingSpaceStatus')
  final String parkingSpaceStatus;

  @JsonKey(name: 'createdDate')
  final String createdDate;

  @JsonKey(name: 'updatedDate')
  final String updatedDate;


  ParkingSpaceInfoResponse(
      this.parkingSpaceID,
      this.vehicleType,
      this.vendorID,
      this.availableSpace,
      this.totalSpace,
      this.rating,
      this.parkingName,
      this.review,
      this.location,
      this.parkingSpaceStatus,
      this.createdDate,
      this.updatedDate);

  factory ParkingSpaceInfoResponse.fromJson(Map<String, dynamic> json) => _$ParkingSpaceInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingSpaceInfoResponseToJson(this);
}
