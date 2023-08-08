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
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
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
    //https://api.mapbox.com/geocoding/v5/mapbox.places/2.3687261219967013,48.863701544984025.json?access_token=YOUR_MAPBOX_ACCESS_TOKEN
    final dio = Dio();
    final response = await dio.get(
      "https://api.mapbox.com/geocoding/v5/mapbox.places/${location.longitude},${location.latitude}.json?access_token=${AppConstants.mapBoxAccessToken}&routing=true",
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>;
      final firstFeature = features.first as Map<String, dynamic>;
      final placeName = firstFeature['place_name'] as String;
      final routablePoint =
          firstFeature['routable_points']['points'] as List<dynamic>;
      final firstRoutablePoint = routablePoint.first as Map<String, dynamic>;
      final LatitudeLongitude codedLocation = LatitudeLongitude(
        firstRoutablePoint["coordinates"][1] as double,
        firstRoutablePoint["coordinates"][0] as double,
      );
      return GeocodedLocation(
        placeName,
        location,
        codedLocation,
      );
    }
    return null;
  }
}
