import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../domain/models/user_activity.dart';
import '../domain/services/activity_service.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class DeviceActivityService extends ActivityService {
  StreamController<UserActivity?>? _activityStreamController;

  Future<bool> isPermissionGrants() async {
    //Listen to onProviderChange to be notified when location authorization changes occur.
    bg.BackgroundGeolocation.onProviderChange((event) {
      print("[providerchange] $event");
    });

    //First ready the plugin with your configuration.
    bg.State state = await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.ACTIVITY_TYPE_AUTOMOTIVE_NAVIGATION,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      activityRecognitionInterval: kDebugMode ? 1000 : 10000,
      locationAuthorizationRequest: "Always",
    ));

    if (!state.enabled) {
      await bg.BackgroundGeolocation.start();
    }

    //Manually request permission with configured locationAuthorizationRequest.
    try {
      int status = await bg.BackgroundGeolocation.requestPermission();
      if (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
        print("[requestPermission] Authorized Always $status");
      } else if (status ==
          bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
        print("[requestPermission] Authorized WhenInUse: $status");
      }
      if (_activityStreamController == null) {
        _activityStreamController = StreamController<UserActivity?>();
      }
      bg.BackgroundGeolocation.onActivityChange((bg.ActivityChangeEvent p0) {
        log('ActivityStream: $p0');
        if (p0.confidence >= 60) {
          _activityStreamController!.add(UserActivity(
            type: isDriving(p0.activity),
            timestamp: DateTime.now(),
          ));
        }
      });
    } catch (error) {
      print("[requestPermission] DENIED: $error");
    }

    return false;
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
    return _activityStreamController!.stream;
  }

  UserActivityType isDriving(String type) {
    if (type == 'in_vehicle' || type == 'on_bicycle') {
      return UserActivityType.driving;
    }
    return UserActivityType.notDriving;
  }
}
