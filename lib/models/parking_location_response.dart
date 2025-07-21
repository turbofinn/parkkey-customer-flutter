import 'dart:convert'; // Required for jsonDecode
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

  @JsonKey(
    name: 'parkingImages',
    fromJson: _decodeParkingImages, // Custom decoder
    toJson: _encodeParkingImages,   // Custom encoder
  )
  final List<String> parkingImages; // Change type to List<String>

  ParkingLocationResponse(this.parkingImages,
  {this.parkingSpaceID,
  this.parkingSpaceName,
  this.latitude,
  this.longitude,
  this.location,
  this.parkingSpaceStatus,
  this.address}
  );

  factory ParkingLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$ParkingLocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParkingLocationResponseToJson(this);

  // Custom decoder for parkingImages
  static List<String> _decodeParkingImages(String images) =>
      List<String>.from(jsonDecode(images));

  // Custom encoder for parkingImages
  static String _encodeParkingImages(List<String> images) =>
      jsonEncode(images);
}
