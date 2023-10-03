import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking/constants.dart';
import 'package:parking/domain/models/geocoded_location.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/models/live_location.dart';
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
  Stream<LiveLocation?> getLiveLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((Position? position) {
      if (position == null) {
        return null;
      }

      return LiveLocation(
        location: LatitudeLongitude(position.latitude, position.longitude),
        speed: position.speed,
      );
    });
  }

  @override
  Future<GeocodedLocation?> getGeocodedLocation(
      LatitudeLongitude location) async {
    try {
      final response = await Dio().get(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${location.longitude},${location.latitude}.json?access_token=${AppConstants.mapBoxAccessToken}&routing=true',
      );
      final features = response.data['features'];
      if (features == null || features.isEmpty) {
        return null;
      }
      final firstFeature = features[0];
      return GeocodedLocation(
        firstFeature['place_name'],
        location,
        LatitudeLongitude(
          firstFeature['center'][1],
          firstFeature['center'][0],
        ),
      );
    } catch (e) {
      return null;
    }
  }
}
