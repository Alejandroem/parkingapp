import 'dart:async';
import 'dart:developer';

import 'package:parking/domain/models/user_activity.dart';
import 'package:parking/domain/services/activity_service.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class DeviceActivityService extends ActivityService {
  StreamController<UserActivity>? activityStreamController;

  Future<bool> isPermissionGrants() async {
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
    activityStreamController ??= StreamController<UserActivity>();

    bg.BackgroundGeolocation.onActivityChange((bg.ActivityChangeEvent event) {
      log("Activity received onActivityChange ${event.toMap().toString()}");
      activityStreamController!.add(
        UserActivity(
          type: (event.activity.contains("on_bycicle") ||
                  event.activity.contains("in_vehicle"))
              ? UserActivityType.driving
              : UserActivityType.notDriving,
          time: DateTime.now(),
        ),
      );
    });

    return activityStreamController!.stream;
  }
}
