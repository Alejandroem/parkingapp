enum UserActivityType {
  driving,
  notDriving,
}

class UserActivity {
  final UserActivityType type;
  final DateTime timestamp;
  UserActivity({
    required this.type,
    required this.timestamp,
  });
}
