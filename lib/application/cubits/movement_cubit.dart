import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/services/location_service.dart';

class MovementState {
  LatitudeLongitude lastKnownLocation;
  double speed;
  double maxSpeed;
  LatitudeLongitude? lastParkedLocation;
  DateTime? lastParkedTime;
  DateTime? lastSwitchOfVelocity;

  MovementState({
    required this.lastKnownLocation,
    required this.speed,
    required this.maxSpeed,
    this.lastParkedLocation,
    this.lastParkedTime,
    this.lastSwitchOfVelocity,
  });
}

class MovementCubit extends Cubit<MovementState> {
  final LocationService _locationService;
  MovementCubit(this._locationService)
      : super(
          MovementState(
            lastKnownLocation: const LatitudeLongitude(0, 0),
            speed: 0,
            maxSpeed: 0,
          ),
        ) {
    _locationService.getLiveLocation().listen((event) {
      log('MovementCubit: ${event?.speed ?? 0 * 3.6} km/h ${event?.location}');
      MovementState newState = MovementState(
        lastKnownLocation: event!.location,
        speed: event.speed,
        maxSpeed: state.maxSpeed,
      );
      if (event.speed < 1 &&
          state.lastSwitchOfVelocity != null &&
          DateTime.now().difference(state.lastSwitchOfVelocity!).inMinutes >
              5) {
        log('MovementCubit: User is walking');
        newState = MovementState(
          lastKnownLocation: event.location,
          speed: event.speed,
          maxSpeed: event.speed,
          lastParkedLocation: event.location,
          lastParkedTime: DateTime.now(),
          lastSwitchOfVelocity: DateTime.now(),
        );
      }
      log('MovementCubit: User is driving');
      emit(newState);
    });
  }

  void updateLastKnownLocation(LatitudeLongitude lastKnownLocation) {
    emit(
      MovementState(
        lastKnownLocation: lastKnownLocation,
        speed: state.speed,
        maxSpeed: state.maxSpeed,
      ),
    );
  }

  void updateSpeed(double speed) {
    emit(
      MovementState(
        lastKnownLocation: state.lastKnownLocation,
        speed: speed,
        maxSpeed: state.maxSpeed,
      ),
    );
  }

  void updateMaxSpeed(double maxSpeed) {
    emit(
      MovementState(
        lastKnownLocation: state.lastKnownLocation,
        speed: state.speed,
        maxSpeed: maxSpeed,
      ),
    );
  }
}
