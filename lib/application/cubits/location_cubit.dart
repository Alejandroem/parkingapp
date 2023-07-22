import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/domain/models/user_locations.dart';
import 'package:parking/domain/services/directions_service.dart';

import '../../domain/models/geocoded_location.dart';
import '../../domain/models/lat_lng.dart';
import '../../domain/services/location_service.dart';

class LocationCubit extends Cubit<UserLocation> {
  final LocationService _locationService;
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
      GeocodedLocation? preciseDestination =
          await _locationService.getGeocodedLocation(state.lastTappedLocation!);
      if (preciseOrigin != null && preciseDestination != null) {
        List<LatitudeLongitude> points = await _directionsService.getDirections(
          origin: preciseOrigin.encodedLocation,
          destination: preciseDestination.encodedLocation,
        );

        emit(
          UserLocation(
            lastTappedLocation: state.lastTappedLocation,
            currentLocation: state.currentLocation,
            polylines: points,
          ),
        );
      }
    }
  }
}
