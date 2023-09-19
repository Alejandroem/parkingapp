import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/models/live_location.dart';
import 'package:parking/domain/models/user_activity.dart';
import 'package:parking/domain/services/activity_service.dart';
import 'package:parking/domain/services/location_service.dart';

enum Accuracy {
  medium,
  high,
}

class ParkingPlace {
  Accuracy accuracy;
  DateTime time;
  LatitudeLongitude location;
  ParkingPlace({
    required this.accuracy,
    required this.time,
    required this.location,
  });
}

class MovementState {
  LatitudeLongitude lastKnownLocation;
  double speed;
  double maxSpeed;
  LatitudeLongitude? lastParkedLocation;
  DateTime? lastSwitchOfActivity;
  DateTime? lastParkedTime;
  DateTime? lastSwitchOfVelocity;
  ParkingPlace? parkingPlace;
  DateTime? lastUpdate;
  UserActivity? userActivity;

  MovementState({
    required this.lastKnownLocation,
    required this.speed,
    required this.maxSpeed,
    this.lastParkedLocation,
    this.lastParkedTime,
    this.lastSwitchOfVelocity,
    this.lastSwitchOfActivity,
    this.userActivity,
    this.parkingPlace,
    this.lastUpdate,
  });

  //copy with method
  MovementState copyWith({
    LatitudeLongitude? lastKnownLocation,
    double? speed,
    double? maxSpeed,
    LatitudeLongitude? lastParkedLocation,
    DateTime? lastParkedTime,
    DateTime? lastSwitchOfVelocity,
    DateTime? lastSwitchOfActivity,
    ParkingPlace? parkingPlace,
    UserActivity? userActivity,
    DateTime? lastUpdate,
  }) {
    return MovementState(
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      speed: speed ?? this.speed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      lastParkedLocation: lastParkedLocation ?? this.lastParkedLocation,
      lastParkedTime: lastParkedTime ?? this.lastParkedTime,
      lastSwitchOfVelocity: lastSwitchOfVelocity ?? this.lastSwitchOfVelocity,
      lastSwitchOfActivity: lastSwitchOfActivity ?? this.lastSwitchOfActivity,
      parkingPlace: parkingPlace ?? this.parkingPlace,
      userActivity: userActivity ?? this.userActivity,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  //override equallity
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovementState &&
          runtimeType == other.runtimeType &&
          lastKnownLocation == other.lastKnownLocation &&
          speed == other.speed &&
          maxSpeed == other.maxSpeed &&
          lastParkedLocation == other.lastParkedLocation &&
          lastParkedTime == other.lastParkedTime &&
          lastSwitchOfVelocity == other.lastSwitchOfVelocity &&
          parkingPlace == other.parkingPlace &&
          lastUpdate == other.lastUpdate &&
          lastSwitchOfActivity == other.lastSwitchOfActivity &&
          userActivity == other.userActivity;

  @override
  int get hashCode => super.hashCode;
}

class MovementCubit extends Cubit<MovementState> {
  final LocationService _locationService;
  final ActivityService _activityService;

  StreamSubscription<LiveLocation?>? _liveLocationStreamSubscription;
  StreamSubscription<UserActivity?>? _activityStreamSubscription;

  //close cubit
  @override
  Future<void> close() async {
    await _liveLocationStreamSubscription?.cancel();
    await _activityStreamSubscription?.cancel();
    super.close();
  }

  MovementCubit(
    this._locationService,
    this._activityService,
  ) : super(
          MovementState(
            lastKnownLocation: const LatitudeLongitude(0, 0),
            speed: 0,
            maxSpeed: 0,
          ),
        ) {
    subscribeToLocationEvents();
    requestPermissionsAndStartTracking();
  }

  void subscribeToLocationEvents() {
    _liveLocationStreamSubscription =
        _locationService.getLiveLocation().listen((event) {
      log('MovementCubit: ${event?.speed ?? 0 * 3.6} km/h ${event?.location}');
      MovementState newState = state.copyWith(
        lastKnownLocation: event!.location,
        speed: event.speed * 3.6,
        maxSpeed: state.maxSpeed,
        lastUpdate: DateTime.now(),
      );
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

  List<String> addToLast10Logs(List<String> last10logs, String s) {
    log('addToLast10Logs: $s');
    //add to last 10 logs remove first if more than 10
    if (last10logs.length > 10) {
      last10logs.removeAt(0);
    }
    last10logs.add(s);
    return last10logs;
  }

  void requestPermissionsAndStartTracking() async {
    await _activityService.askForActivityPermission();
    _activityStreamSubscription = _activityService.getActivityStream().listen(
      (event) {
        if (userIsDriving(event)) {
          updateLastSeenDrivingAndDeleteParkingTime(event);
        }
        if (userNotDrivingAfterDriving(event)) {
          updateLastPossibleParkingLocation(event);
        }
        if (userHasNotBeenDrivingForFiveMinutes(event)) {
          updateLastParkedTime(event);
        }
      },
    );
  }

  bool userIsDriving(UserActivity? event) {
    return event != null && event.type == UserActivityType.driving;
  }

  void updateLastSeenDrivingAndDeleteParkingTime(UserActivity? event) {
    emit(
      state.copyWith(
        lastSwitchOfActivity: DateTime.now(),
        lastParkedTime: null,
        lastParkedLocation: null,
        userActivity: event,
      ),
    );
  }

  bool userNotDrivingAfterDriving(UserActivity? event) {
    return event != null &&
        event.type == UserActivityType.notDriving &&
        state.userActivity?.type == UserActivityType.driving;
  }

  void updateLastPossibleParkingLocation(UserActivity? event) {
    emit(
      state.copyWith(
        lastSwitchOfActivity: DateTime.now(),
        lastParkedTime: null,
        lastParkedLocation: state.lastKnownLocation,
        userActivity: event,
      ),
    );
  }

  bool userHasNotBeenDrivingForFiveMinutes(UserActivity? event) {
    return event != null &&
        event.type == UserActivityType.notDriving &&
        state.userActivity?.type == UserActivityType.notDriving &&
        state.lastParkedTime != null &&
        DateTime.now().difference(state.lastParkedTime!) >
            const Duration(minutes: 5);
  }

  void updateLastParkedTime(UserActivity? event) {
    emit(
      state.copyWith(
        lastSwitchOfActivity: DateTime.now(),
        lastParkedTime: DateTime.now(),
        userActivity: event,
      ),
    );
  }
}
