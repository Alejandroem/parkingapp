import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(TrafficMapApp());
}

class TrafficMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrafficMap(),
    );
  }
}

class TrafficMap extends StatefulWidget {
  @override
  _TrafficMapState createState() => _TrafficMapState();
}

class _TrafficMapState extends State<TrafficMap> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Map'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(48.88246946770146,2.3078547543281744), // Paris 8e
          zoom: 12.0,
        ),
        trafficEnabled: true, // Enable traffic data
      ),
    );
  }
}
