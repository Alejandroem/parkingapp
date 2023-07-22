import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/domain/models/user_locations.dart';

import '../../domain/models/lat_lng.dart';
import '../../domain/services/location_service.dart';

class LocationCubit extends Cubit<UserLocation> {
  final LocationService _locationService;
  LocationCubit(
    this._locationService,
  ) : super(
          UserLocation(
            lastTappedLocation: null,
            currentLocation: null,
          ),
        ) {
    _locationService.getLocation().then((location) {
      emit(
        UserLocation(
          lastTappedLocation: state.lastTappedLocation,
          currentLocation: location,
        ),
      );
    });
  }

  void updateLastTappedLocation(double latitude, double longitude) {
    emit(
      UserLocation(
        lastTappedLocation: LatitudeLongitude(
          latitude,
          longitude,
        ),
        currentLocation: state.currentLocation,
      ),
    );
  }
}
