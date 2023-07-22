import 'package:parking/domain/models/lat_lng.dart';

import '../models/geocoded_location.dart';

abstract class LocationService {
  Future<LatitudeLongitude> getLocation();
  Future<bool> askForLocationPermission();
  Stream<LatitudeLongitude?> getLiveLocation();
  Future<GeocodedLocation?> getGeocodedLocation(LatitudeLongitude location);
}
