import '../models/geocoded_location.dart';
import '../models/lat_lng.dart';
import '../models/live_location.dart';

abstract class UserLocationService {
  Future<LatitudeLongitude> getLocation();
  Future<bool> askForLocationPermission();
  Stream<LiveLocation?> getLiveLocation();
  Future<GeocodedLocation?> getGeocodedLocation(LatitudeLongitude location);

  Future<GeocodedLocation?> getGeocodedLocationFromAddress(String selection);
}
