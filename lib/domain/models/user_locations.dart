import 'package:parking/domain/models/lat_lng.dart';

class UserLocation {
  LatitudeLongitude? lastTappedLocation;
  LatitudeLongitude? currentLocation;
  List<LatitudeLongitude>? polylines;

  UserLocation({
    required this.lastTappedLocation,
    required this.currentLocation,
    required this.polylines,
  });
}
