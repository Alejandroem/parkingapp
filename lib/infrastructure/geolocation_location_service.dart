import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:parking/constants.dart';
import 'package:parking/domain/models/geocoded_location.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/models/live_location.dart';
import 'package:parking/domain/services/location_service.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeolocationLocationService extends LocationService {
  StreamController<LiveLocation?>? locationsStreamController;

  @override
  Future<LatitudeLongitude> getLocation() async {
    await askForLocationPermission();
    bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
        timeout: 30, // 30 second timeout to fetch location
        maximumAge:
            5000, // Accept the last-known-location if not older than 5000 ms.
        desiredAccuracy:
            10, // Try to fetch a location with an accuracy of `10` meters.
        samples: 3, // How many location samples to attempt.
        extras: {
          // [Optional] Attach your own custom meta-data to this location.  This meta-data will be persisted to SQLite and POSTed to your server
          "method": "getLocation"
        });
    return LatitudeLongitude(
        location.coords.latitude, location.coords.longitude);
  }

  @override
  Future<bool> askForLocationPermission() async {
    return true;
  }

  @override
  Stream<LiveLocation?> getLiveLocation() {
    locationsStreamController ??= StreamController<LiveLocation?>();
    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      locationsStreamController!.add(
        LiveLocation(
          location: LatitudeLongitude(
            event.location.coords.latitude,
            event.location.coords.longitude,
          ),
          speed: event.location.coords.speed,
        ),
      );
    });
    return locationsStreamController!.stream;
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

  @override
  Future<void> initializeLocationServices() async {
    bg.State state = await bg.BackgroundGeolocation.ready(
      bg.Config(
        reset:
            false, // <-- lets the Settings screen drive the config rather than re-applying each boot.
        // Convenience option to automatically configure the SDK to post to Transistor Demo server.
        //transistorAuthorizationToken: token,
        // Logging & Debug
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        // Geolocation options
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter: 10.0,
        // Activity recognition options
        stopTimeout: 5,
        backgroundPermissionRationale: bg.PermissionRationale(
            title:
                "Allow {applicationName} to access this device's location even when the app is closed or not in use.",
            message:
                "This app collects location data to enable recording your trips to work and calculate distance-travelled.",
            positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
            negativeAction: 'Cancel'),
        // HTTP & Persistence
        autoSync: true,
        // Application options
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        heartbeatInterval: 60,
      ),
    );

    log('[ready] ${state.toMap()}');
    log('[didDeviceReboot] ${state.didDeviceReboot}');

    if (state.schedule!.isNotEmpty) {
      bg.BackgroundGeolocation.startSchedule();
    }

    if (state.enabled) {
      log('Background location tracking enabled');
    }

    if (state.isMoving ?? false) {
      log("User is moving");
    }
  }
}
