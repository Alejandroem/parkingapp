import 'package:parking/domain/models/lat_lng.dart';

class UserLocation {
  LatitudeLongitude? lastTappedLocation;
  LatitudeLongitude? currentLocation;

  UserLocation({
    required this.lastTappedLocation,
    required this.currentLocation,
  });
}
