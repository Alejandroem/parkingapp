import 'dart:async';
import 'dart:developer';

import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/models/live_location.dart';
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
  DateTime? lastParkedTime;
  DateTime? lastSwitchOfVelocity;
  List<ParkingPlace>? parkingPlaces;
  DateTime? lastUpdate;

  MovementState({
    required this.lastKnownLocation,
    required this.speed,
    required this.maxSpeed,
    this.lastParkedLocation,
    this.lastParkedTime,
    this.lastSwitchOfVelocity,
    this.parkingPlaces,
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
    List<ParkingPlace>? parkingPlaces,
    DateTime? lastUpdate,
  }) {
    return MovementState(
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      speed: speed ?? this.speed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      lastParkedLocation: lastParkedLocation ?? this.lastParkedLocation,
      lastParkedTime: lastParkedTime ?? this.lastParkedTime,
      lastSwitchOfVelocity: lastSwitchOfVelocity ?? this.lastSwitchOfVelocity,
      parkingPlaces: parkingPlaces ?? this.parkingPlaces,
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
          parkingPlaces == other.parkingPlaces &&
          lastUpdate == other.lastUpdate;

  @override
  int get hashCode => super.hashCode;
}

class MovementCubit extends Cubit<MovementState> {
  final LocationService _locationService;
  FlutterActivityRecognition activityRecognition =
      FlutterActivityRecognition.instance;

  StreamSubscription<LiveLocation?>? _liveLocationStreamSubscription;
  StreamSubscription<Activity>? _activityStreamSubscription;

  //close cubit
  @override
  Future<void> close() async {
    await _liveLocationStreamSubscription?.cancel();
    await _activityStreamSubscription?.cancel();
    super.close();
  }

  MovementCubit(this._locationService)
      : super(
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

  void requestPermissionsAndStartTracking() async {
    await isPermissionGrants();
    _activityStreamSubscription = activityRecognition.activityStream.listen(
      (Activity event) {
        log('ActivityStream: $event');
        if (event.confidence == ActivityConfidence.MEDIUM ||
            event.confidence == ActivityConfidence.HIGH) {
          if (event.type == ActivityType.STILL) {
            //LatitudeLongitude location = (await _locationService.getLocation());
            log('ActivityStream: User is still at Latitude ${state.lastKnownLocation} Longitude ${state.lastKnownLocation}');
            emit(
              state.copyWith(
                lastParkedLocation: state.lastKnownLocation,
                lastParkedTime: DateTime.now(),
                lastSwitchOfVelocity: DateTime.now(),
                parkingPlaces: [
                  ...(state.parkingPlaces ?? []),
                  ParkingPlace(
                    accuracy: ActivityConfidence.HIGH == event.confidence
                        ? Accuracy.high
                        : Accuracy.medium,
                    time: DateTime.now(),
                    location: state.lastKnownLocation,
                  ),
                ],
                lastUpdate: DateTime.now(),
              ),
            );
          } else if (event.type == ActivityType.WALKING ||
              event.type == ActivityType.RUNNING ||
              event.type == ActivityType.ON_BICYCLE ||
              event.type == ActivityType.IN_VEHICLE) {
            log('ActivityStream: User is moving');
            emit(
              state.copyWith(
                lastParkedLocation: null,
                lastParkedTime: null,
                lastSwitchOfVelocity: DateTime.now(),
                lastUpdate: DateTime.now(),
              ),
            );
          }
          return;
        }
      },
      onError: (e) {
        log('ActivityStream: $e');
        emit(
          state.copyWith(
            lastParkedLocation: null,
            lastParkedTime: null,
            lastSwitchOfVelocity: DateTime.now(),
          ),
        );
      },
      onDone: () {
        log('ActivityStream: Done');
        emit(
          state.copyWith(
            lastParkedLocation: null,
            lastParkedTime: null,
            lastSwitchOfVelocity: DateTime.now(),
          ),
        );
      },
      cancelOnError: false,
    );
  }

  Future<bool> isPermissionGrants() async {
    // Check if the user has granted permission. If not, request permission.
    PermissionRequestResult reqResult;
    reqResult = await activityRecognition.checkPermission();
    if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
      log('Permission is permanently denied.');
      return false;
    } else if (reqResult == PermissionRequestResult.DENIED) {
      reqResult = await activityRecognition.requestPermission();
      if (reqResult != PermissionRequestResult.GRANTED) {
        log('Permission is denied.');
        return false;
      }
    }

    return true;
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
}
