import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';
import '../domain/models/geocoded_location.dart';
import '../domain/models/lat_lng.dart';
import '../domain/models/live_location.dart';
import '../domain/services/location_service.dart';

class GeolocationLocationService extends UserLocationService {
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
    LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: kDebugMode ? 1 : 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Parking app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
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

  @override
  Future<GeocodedLocation?> getGeocodedLocationFromAddress(
      String selection) async {
    try {
      final response = await Dio().get(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$selection.json?access_token=${AppConstants.mapBoxAccessToken}&routing=true',
      );
      final features = response.data['features'];
      if (features == null || features.isEmpty) {
        return null;
      }
      final firstFeature = features[0];
      return GeocodedLocation(
        firstFeature['place_name'],
        LatitudeLongitude(
          firstFeature['center'][1],
          firstFeature['center'][0],
        ),
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
