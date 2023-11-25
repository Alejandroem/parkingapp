import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/lat_lng.dart';
import '../../domain/models/live_location.dart';
import '../../domain/models/user_activity.dart';
import '../../domain/services/activity_service.dart';
import '../../domain/services/location_service.dart';

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
          lastUpdate == other.lastUpdate &&
          lastSwitchOfActivity == other.lastSwitchOfActivity &&
          userActivity == other.userActivity;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  MovementState clearParkingTimeAndLocation() {
    return MovementState(
      lastKnownLocation: lastKnownLocation,
      speed: speed,
      maxSpeed: maxSpeed,
      lastParkedLocation: null,
      lastParkedTime: null,
      lastSwitchOfVelocity: lastSwitchOfVelocity,
      lastSwitchOfActivity: lastSwitchOfActivity,
      userActivity: userActivity,
      lastUpdate: lastUpdate,
    );
  }
}

class MovementCubit extends Cubit<MovementState> {
  final UserLocationService _locationService;
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
    log("I passed here");
    //subscribeToLocationEvents();
    //requestPermissionsAndStartTracking();
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
    //_activityStreamSubscription = _activityService.getActivityStream().listen(
    Stream<UserActivity> fakeStream = Stream<UserActivity>.periodic(
      const Duration(seconds: 10),
      (count) {
        log('activityStream: $count');

        int lastDigitOfCount = count % 10;
        if (lastDigitOfCount < 5) {
          //driving
          return UserActivity(
            type: UserActivityType.driving,
            timestamp: DateTime.now(),
          );
        } else {
          //not driving
          return UserActivity(
            type: UserActivityType.notDriving,
            timestamp: DateTime.now(),
          );
        }
      },
    );

    if (kDebugMode && false) {
      _activityStreamSubscription = fakeStream.listen(
        onEvent,
        onError: (e) {
          log('activityStream: $e');
        },
        onDone: () {
          log('activityStream: done');
        },
      );
    } else {
      _activityStreamSubscription = _activityService.getActivityStream().listen(
        onEvent,
        onError: (e) {
          log('activityStream: $e');
        },
        onDone: () {
          log('activityStream: done');
        },
      );
    }
  }

  void onEvent(event) {
    log('MovementCubit: $event');
    log('MovementCubit: ${event.timestamp}');
    log('MovementCubit: ${event.type}');
    if (userIsDriving(event)) {
      updateLastSeenDrivingAndDeleteParkingTime(event);
    }
    if (userNotDrivingAfterDriving(event)) {
      updateLastPossibleParkingLocation(event);
    }
    if (userHasNotBeenDrivingForFiveMinutes(event)) {
      updateLastParkedTime(event);
    }
  }

  bool userIsDriving(UserActivity? event) {
    return event != null && event.type == UserActivityType.driving;
  }

  void updateLastSeenDrivingAndDeleteParkingTime(UserActivity? event) {
    log('updateLastSeenDrivingAndDeleteParkingTime');
    emit(
      state.copyWith(
        lastSwitchOfActivity: event?.timestamp,
        lastParkedTime: null,
        lastParkedLocation: null,
        userActivity: event,
      ),
    );
    emit(state.clearParkingTimeAndLocation());
  }

  bool userNotDrivingAfterDriving(UserActivity? event) {
    return event != null &&
        event.type == UserActivityType.notDriving &&
        state.userActivity?.type == UserActivityType.driving;
  }

  void updateLastPossibleParkingLocation(UserActivity? event) async {
    log('updateLastPossibleParkingLocation');
    LatitudeLongitude location = await _locationService.getLocation();
    emit(
      state.copyWith(
        lastSwitchOfActivity: event?.timestamp,
        lastParkedTime: null,
        lastParkedLocation: location,
        userActivity: event,
      ),
    );
  }

  bool userHasNotBeenDrivingForFiveMinutes(UserActivity? event) {
    return event != null &&
        event.type == UserActivityType.notDriving &&
        state.userActivity?.type == UserActivityType.notDriving &&
        event.timestamp.difference(state.lastSwitchOfActivity!) >
            (kDebugMode
                ? const Duration(seconds: 30)
                : const Duration(minutes: 5));
  }

  void updateLastParkedTime(UserActivity? event) {
    log('updateLastParkedTime');
    emit(
      state.copyWith(
        lastSwitchOfActivity: event!.timestamp,
        lastParkedTime: event.timestamp,
        userActivity: event,
      ),
    );
  }
}
