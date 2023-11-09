import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poly_geofence_service/models/lat_lng.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isUserAtLocationResult = false;

  // Define a radius (in meters) within which the user is considered to be at the location.
  double radius = 1000; // 1 kilometer

  var position0, position1, position2;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  List<LatLng> locationPoints = [
    LatLng(37.7749, -122.4194), // San Francisco, CA
    LatLng(34.0522, -118.2437), // Los Angeles, CA
    LatLng(40.7128, -74.0060),  // New York, NY
    // Add more location points as needed
  ];


  Future<bool> isUserAtLocation(List<LatLng> locations) async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    for (LatLng location in locations) {
      double distance = await Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        location.latitude,
        location.longitude,
      );

      if (distance <= radius) {
        return true;
      }
    }

    return false;
  }


  @override
  Future<void> initState() async {
    super.initState();
    position0 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    checkUserLocation();
  }

  Future<void> checkUserLocation() async {
    bool result = await isUserAtLocation(locationPoints);
    setState(() {
      isUserAtLocationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isUserAtLocationResult
                  ? 'You are at one of the locations.'
                  : 'You are not at any of the locations.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
