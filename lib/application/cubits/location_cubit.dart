import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../../domain/models/geocoded_location.dart';
import '../../domain/models/lat_lng.dart';
import '../../domain/models/user_locations.dart';
import '../../domain/services/directions_service.dart';
import '../../domain/services/location_service.dart';

class LocationCubit extends Cubit<UserLocation> {
  final UserLocationService _locationService;
  final DirectionsService _directionsService;
  LocationCubit(
    this._locationService,
    this._directionsService,
  ) : super(
          UserLocation(
            lastTappedLocation: null,
            currentLocation: null,
            polylines: null,
          ),
        ) {
    _locationService.getLocation().then((location) {
      emit(
        UserLocation(
          lastTappedLocation: state.lastTappedLocation,
          currentLocation: location,
          polylines: state.polylines,
        ),
      );
    });
    updateCurrentLocation();
  }

  void updateCurrentLocation() async {
    var location = await _locationService.getLocation();
    emit(
      UserLocation(
        lastTappedLocation: state.lastTappedLocation,
        currentLocation: location,
        polylines: state.polylines,
      ),
    );
  }

  void updateLastTappedLocation(double latitude, double longitude) async {
    emit(
      UserLocation(
        lastTappedLocation: LatitudeLongitude(
          latitude,
          longitude,
        ),
        currentLocation: state.currentLocation,
        polylines: state.polylines,
      ),
    );

    if (state.currentLocation != null && state.lastTappedLocation != null) {
      GeocodedLocation? preciseOrigin =
          await _locationService.getGeocodedLocation(state.currentLocation!);
      log('preciseOrigin: $preciseOrigin');
      GeocodedLocation? preciseDestination =
          await _locationService.getGeocodedLocation(state.lastTappedLocation!);
      log('preciseDestination: $preciseDestination');
      if (preciseOrigin != null && preciseDestination != null) {
        List<LatitudeLongitude> points = await _directionsService.getDirections(
          origin: state.currentLocation!,
          destination: state.lastTappedLocation!,
        );

        List<WayPoint>? wayPoints = await _directionsService.getWayPoints(
          origin: state.currentLocation!,
          destination: state.lastTappedLocation!,
        );

        emit(
          UserLocation(
            lastTappedLocation: state.lastTappedLocation,
            currentLocation: state.currentLocation,
            polylines: points,
            wayPoints: wayPoints,
          ),
        );
      }
    }
  }

  void updateLastTappedLocationFromAddress(String selection) async {
    GeocodedLocation? geocodedLocation =
        await _locationService.getGeocodedLocationFromAddress(selection);
    if (geocodedLocation != null) {
      updateLastTappedLocation(
        geocodedLocation.encodedLocation.latitude,
        geocodedLocation.encodedLocation.longitude,
      );
    }
  }
}
