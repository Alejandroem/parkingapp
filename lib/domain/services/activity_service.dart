import '../models/user_activity.dart';

abstract class ActivityService {
  Future<bool> askForActivityPermission();
  Future<bool> checkActivityPermission();
  Stream<UserActivity?> getActivityStream();
}
