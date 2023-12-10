import 'dart:async';

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
  Future<void> initializeLocationServices() async {}
}
