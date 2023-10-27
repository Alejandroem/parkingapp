import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:parking/domain/models/lat_lng.dart';

abstract class DirectionsService {
  Future<List<LatitudeLongitude>> getDirections(
      {required LatitudeLongitude origin,
      required LatitudeLongitude destination});
  Future<List<WayPoint>?> getWayPoints(
      {required LatitudeLongitude origin,
      required LatitudeLongitude destination});

  Future<List<String>> getSearchSuggestions(String query);

  getLocationFromAddress(String address) {}
}
