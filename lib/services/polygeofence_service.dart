import 'dart:async';
import 'package:flutter/material.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';

void main() => runApp(const ExamplePolyGeof());

class ExamplePolyGeof extends StatefulWidget {
  const ExamplePolyGeof({Key? key}) : super(key: key);

  @override
  _ExamplePolyGeofState createState() => _ExamplePolyGeofState();
}

class _ExamplePolyGeofState extends State<ExamplePolyGeof> {

  final _streamController = StreamController<PolyGeofence>();

  int inpolygeofence = 0;

  // Create a [PolyGeofenceService] instance and set options.
  final _polyGeofenceService = PolyGeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      allowMockLocations: false,
      printDevLog: false);

  // Create a [PolyGeofence] list.
  final _polyGeofenceList = <PolyGeofence>[
    PolyGeofence(
      id: 'Yongdusan_Park',
      data: {
        'address': '37-55 Yongdusan-gil, Gwangbokdong 2(i)-ga, Jung-gu, Busan',
        'about': 'Mountain park known for its 129m-high observation tower, statues & stone monuments.',
      },
      // Test avec polygone Ville de Paris : 8F, 8J, 8K et 8H
      polygon: <LatLng>[
        const LatLng(48.867504, 2.299248),
        const LatLng(48.873383, 2.295423),
        const LatLng(48.875076, 2.309177),
        const LatLng(48.876483, 2.307869),
        const LatLng(48.880376, 2.308952),
        const LatLng(48.881295, 2.316480),
        const LatLng(48.877898, 2.326919),
        const LatLng(48.881295, 2.316480),
        const LatLng(48.875537, 2.326559),
        const LatLng(48.873731, 2.327058),
        const LatLng(48.872732, 2.326608),
        const LatLng(48.869601, 2.325870),
        const LatLng(48.869500, 2.325149),
        const LatLng(48.868992, 2.325321),
        const LatLng(48.865094, 2.322432),
        const LatLng(48.870565, 2.305298),
        const LatLng(48.867504, 2.299248),
      ],
    ),
  ];

  // This function is to be called when the geofence status is changed.
  Future<void> _onPolyGeofenceStatusChanged(
      PolyGeofence polyGeofence,
      PolyGeofenceStatus polyGeofenceStatus,
      Location location) async {
    print('polyGeofence: ${polyGeofence.toJson()}');
    print('polyGeofenceStatus: ${polyGeofenceStatus.toString()}');
    _streamController.sink.add(polyGeofence);
    inpolygeofence = 1;
    print ('------------------------------------------------');
    print('Geofence Status: ${polyGeofenceStatus.toString()}');
    print ('------------------------------------------------');
    switch (polyGeofenceStatus) {
      case PolyGeofenceStatus.ENTER:
        inpolygeofence = 1;
        break;
      case PolyGeofenceStatus.DWELL:
        inpolygeofence = 2;
        break;
      case PolyGeofenceStatus.EXIT:
        inpolygeofence = 0;
        break;
    }
    print ('************************************************************');
    print(' Status: $inpolygeofence');
    print ('************************************************************');

  }

  // This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
  }

  // This function is to be called when a location services status change occurs
  // since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

  // This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _polyGeofenceService.addPolyGeofenceStatusChangeListener(_onPolyGeofenceStatusChanged);
      _polyGeofenceService.addLocationChangeListener(_onLocationChanged);
      _polyGeofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
      _polyGeofenceService.addStreamErrorListener(_onError);
      _polyGeofenceService.start(_polyGeofenceList).catchError(_onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // A widget used when you want to start a foreground task when trying to minimize or close the app.
      // Declare on top of the [Scaffold] widget.
      home: WillStartForegroundTask(
        onWillStart: () async {
          // You can add a foreground task start condition.
          return _polyGeofenceService.isRunningService;
        },
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'geofence_service_notification_channel',
          channelName: 'Geofence Service Notification',
          channelDescription: 'This notification appears when the geofence service is running in the background.',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
          isSticky: false,
        ),
        iosNotificationOptions: const IOSNotificationOptions(),
        notificationTitle: 'Geofence Service is running',
        notificationText: 'Tap to return to the app',
        foregroundTaskOptions: const ForegroundTaskOptions(
          interval: 5000,
          isOnceEvent: false,
          autoRunOnBoot: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Poly Geofence Service'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings,color: Colors.white,),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          body: _buildContentView(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Widget _buildContentView() {
    return StreamBuilder<PolyGeofence>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();
        final content = snapshot.data?.toJson().toString() ?? '';
        final inZone = snapshot.data?.status ?? '';

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          children: [
          //  Text('•\t\tPolyGeofence (updated: $updatedDateTime)'),
         //   const SizedBox(height: 10.0),
          //  Text(content),
            const SizedBox(height: 20.0),
          //  (stream.status == 'ENTER') ? 'Dans la zone' : 'Hors de la zone';
            Text('•\t\tPolyGeofence Statut: $inZone '), // and speed is : $_streamController.$speed'),
          ],
        );
      },
    );
  }
}