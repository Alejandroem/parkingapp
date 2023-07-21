import 'package:parking/domain/models/lat_lng.dart';

abstract class LocationService {
  Future<LatitudeLongitude> getLocation();
  Future<bool> askForLocationPermission();
  Stream<LatitudeLongitude?> getLiveLocation();
}
