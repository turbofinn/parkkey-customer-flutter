import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkey_customer/utils/Constants.dart';

class DistanceCalculator {
  final String apiKey = Constants.GOOGLE_MAP_API_KEY;
  final Dio dio;

  DistanceCalculator() : dio = Dio();

  Future<double?> getDistance({required LatLng origin, required LatLng destination}) async {
    final url = 'https://maps.googleapis.com/maps/api/distancematrix/json';

    try {
      final response = await dio.get(url, queryParameters: {
        'units': 'metric',
        'origins': '${origin.latitude},${origin.longitude}',
        'destinations': '${destination.latitude},${destination.longitude}',
        'key': apiKey,
      });

      print('object---');
      print(response);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['rows'][0]['elements'][0]['status'] == 'OK') {
          final distanceInMeters = data['rows'][0]['elements'][0]['distance']['value'];
          return distanceInMeters / 1000; // Convert to kilometers
        } else {
          print('Error: ${data['rows'][0]['elements'][0]['status']}');
          return null;
        }
      } else {
        print('Failed to get distance: ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
