enum UserActivityType {
  driving,
  notDriving,
}

class UserActivity {
  final UserActivityType type;
  final DateTime time;
  UserActivity({
    required this.type,
    required this.time,
  });
}
