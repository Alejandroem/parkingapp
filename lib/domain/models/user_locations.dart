import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import 'lat_lng.dart';

class UserLocation {
  LatitudeLongitude? lastTappedLocation;
  LatitudeLongitude? currentLocation;
  List<WayPoint>? wayPoints;
  List<LatitudeLongitude>? polylines;

  UserLocation({
    required this.lastTappedLocation,
    required this.currentLocation,
    required this.polylines,
    this.wayPoints,
  });
}
