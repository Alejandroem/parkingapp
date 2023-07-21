import 'package:geolocator/geolocator.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/services/location_service.dart';

class GeolocationLocationService extends LocationService {
  @override
  Future<LatitudeLongitude> getLocation() async {
    await askForLocationPermission();
    Position position = await Geolocator.getCurrentPosition();
    return LatitudeLongitude(position.latitude, position.longitude);
  }

  @override
  Future<bool> askForLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  @override
  Stream<LatitudeLongitude?> getLiveLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((Position? position) {
      if (position == null) {
        return null;
      }
      return LatitudeLongitude(position.latitude, position.longitude);
    });
  }
}
