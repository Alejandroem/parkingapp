import 'dart:developer';

import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:parking/domain/models/user_activity.dart';
import 'package:parking/domain/services/activity_service.dart';

class DeviceActivityService extends ActivityService {
  FlutterActivityRecognition activityRecognition =
      FlutterActivityRecognition.instance;

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

  @override
  Future<bool> askForActivityPermission() async {
    return await isPermissionGrants();
  }

  @override
  Future<bool> checkActivityPermission() async {
    return await isPermissionGrants();
  }

  @override
  Stream<UserActivity?> getActivityStream() {
    /*  _activityStreamSubscription = activityRecognition.activityStream.listen(
      (Activity event) {
        log('ActivityStream: $event');
        if (event.confidence == ActivityConfidence.MEDIUM ||
            event.confidence == ActivityConfidence.HIGH) {
          if (userIsInVehicle(event)) {
            updateLastUserSeenInVehicle(event);
          }
          if (userIsOnFootAfterAVehicle(event)) {
            updateLastPossibleParkingPlace(event);
          }
          if (userHasBeenOnFootForFiveMinutes(event)) {
            updateLastParkedPosition(event);
          }
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
    ); */

    return activityRecognition.activityStream.map((event) {
      log('ActivityStream: $event');
      if (event.confidence == ActivityConfidence.MEDIUM ||
          event.confidence == ActivityConfidence.HIGH) {
        return UserActivity(
          type: isDriving(event.type),
          timestamp: DateTime.now(),
        );
      }
      //skip the others
      return null;
    });
  }

  UserActivityType isDriving(ActivityType type) {
    if (type == ActivityType.IN_VEHICLE || type == ActivityType.ON_BICYCLE) {
      return UserActivityType.driving;
    }
    return UserActivityType.notDriving;
  }
}
