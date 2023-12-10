import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/models/live_location.dart';

import '../models/geocoded_location.dart';

abstract class LocationService {
  Future<void> initializeLocationServices();

  Future<LatitudeLongitude> getLocation();
  Future<bool> askForLocationPermission();
  Stream<LiveLocation?> getLiveLocation();
  Future<GeocodedLocation?> getGeocodedLocation(LatitudeLongitude location);

  Future<GeocodedLocation?> getGeocodedLocationFromAddress(String selection);
}
