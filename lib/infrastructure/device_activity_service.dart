
import '../domain/models/user_activity.dart';
import '../domain/services/activity_service.dart';

class DeviceActivityService extends ActivityService {

  Future<bool> isPermissionGrants() async {
    
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
    /* return activityRecognition
        .activityStream(runForegroundService: true)
        .map((ActivityEvent event) {
      log('ActivityStream: $event');
      if (event.confidence >= 60) {
        return UserActivity(
          type: isDriving(event.type),
          timestamp: DateTime.now(),
        );
      }
      //skip the others
      return null;
    }); */
    return Stream.empty();
  }

/*   UserActivityType isDriving(ActivityType type) {
    if (type == ActivityType.IN_VEHICLE || type == ActivityType.ON_BICYCLE) {
      return UserActivityType.driving;
    }
    return UserActivityType.notDriving;
  } */
}
