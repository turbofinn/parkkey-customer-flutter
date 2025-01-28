
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointsModel{
LatLng point;
String parkingSpaceID;
double distance;
final List<String> parkingImages; // Include parking images

 PointsModel(
    this.point,
    this.parkingSpaceID,
    this.distance, {
    required this.parkingImages,
  });
}