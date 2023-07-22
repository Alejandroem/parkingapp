import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_polyline_points_plus/flutter_polyline_points_plus.dart';
import 'package:parking/domain/models/lat_lng.dart';

import '../constants.dart';
import '../domain/services/directions_service.dart';

class MapboxDirectionsService extends DirectionsService {
  @override
  Future<List<LatitudeLongitude>> getDirections(
      {required LatitudeLongitude origin,
      required LatitudeLongitude destination}) async {
    try {
      final dio = Dio();
      final data = {
        'coordinates':
            "${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}",
        'radiuses': '2000;2000',
      };
      final response = await dio.post(
        "https://api.mapbox.com/directions/v5/mapbox/driving?access_token=${AppConstants.mapBoxAccessToken}&waypoints_per_route=true",
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.statusCode == 200) {
        log(response.data.toString());
        final data = response.data as Map<String, dynamic>;
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result =
            polylinePoints.decodePolyline(data["routes"].first["geometry"]);
        return result.map((PointLatLng point) {
          return LatitudeLongitude(
            point.latitude,
            point.longitude,
          );
        }).toList();
      }
    } catch (e) {
      log("Error getting directions $e");
    }
    return [];
  }
}
