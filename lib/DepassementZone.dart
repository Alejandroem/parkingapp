//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
void main() => runApp(LocationAlertApp());

class LocationAlertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationAlertScreen(),
    );
  }
}

class LocationAlertScreen extends StatefulWidget {
  @override
  _LocationAlertScreenState createState() => _LocationAlertScreenState();
}

class _LocationAlertScreenState extends State<LocationAlertScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool isInsideLocation = false;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    final initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }



  Future<void> startLocationTracking() async {
    final locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Minimum distance (in meters) to trigger updates
    );

    Geolocator.getPositionStream().listen((position) {
      // Replace these coordinates with your target location's coordinates
      final targetLocation = Position(latitude: 37.7749, longitude: -122.4194);

      final distance = Geolocator.distanceBetween(
        targetLocation.latitude,
        targetLocation.longitude,
        position.latitude,
        position.longitude,
      );

      if (distance < 50) {
        if (!isInsideLocation) {
          displayNotification('Entered Location', 'You entered the target location.');
          isInsideLocation = true;
        }
      } else {
        isInsideLocation = false;
      }
    });
  }

  Future<void> displayNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'location_alert_app',
      'Location Alert App',
      'Channel for location alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification selection here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Alert App'),
      ),
      body: Center(
        child: Text(
          'You will be alerted when you cross a location.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}


 */