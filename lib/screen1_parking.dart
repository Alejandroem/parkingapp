// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/models/android_notification_options.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_foreground_task/models/foreground_task_options.dart';
import 'package:flutter_foreground_task/models/ios_notification_options.dart';
import 'package:flutter_foreground_task/models/notification_channel_importance.dart';
import 'package:flutter_foreground_task/models/notification_priority.dart';
import 'package:flutter_foreground_task/ui/will_start_foreground_task.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:poly_geofence_service/poly_geofence_service.dart'
    as poly_geofence;
import 'package:poly_geofence_service/models/poly_geofence.dart';

import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

import '../amendes/amendes_scanner.dart';
import '../paybyphone/parking_browser.dart';
import '../constants.dart';
import '../services/webview2.dart';
import '../databases/databases.dart';
import '../drawerscreens/mespapiers.dart';
import '../model/dev_en_cours.dart';
import '../errors/error_codes.dart';
import '../services/count-down_timer.dart';
import '../services/location_service.dart';
import '../amendes/amendes_list.dart';
import '../screen2_road.dart';
import 'domain/models/lat_lng.dart';
import 'widgets/parking_map.dart';

class screen1_parking extends StatefulWidget {
  const screen1_parking({
    super.key,
    this.androidDrawer,
    this.immatriculation,
    this.lat,
    this.lon,
    this.isInZone,
    this.CurrentActivity,
    this.expResident,
    this.expVisiteur,
    this.expHandi,
    this.LastAdresse,
    this.residential_zone,
    this.econnect,
    this.bluetooth,
    this.newcarpark,
  });

  final Widget? androidDrawer;
  final String? immatriculation;
  final double? lat;
  final double? lon;
  final int? isInZone;
  final String? residential_zone;
  final int? CurrentActivity;
  final String? expResident;
  final String? expVisiteur;
  final String? expHandi;
  final String? LastAdresse;
  final int? econnect;
  final int? bluetooth;
  final int? newcarpark;

  @override
  State<screen1_parking> createState() => screen1_parkingState();
}

class screen1_parkingState extends State<screen1_parking> {
//  const screen1_parking({super.key});

  var previousActivity;
  var actualActivity;
  var currentActivity;
  var activityType;
  var CarParkingGeolocalisation;
  var CarParkingAdresse;
  var CarParkingDateTime;
  var CarSpeed = 0.00;
  var CarState = 99;
  var inpolygeofence = 99;

  String _plate = "";
  String _econnect = "";

  var _lat;
  var _lon;
  var _adr;
  var _tim;
  var _width;
  var _height;
  var _zone;
  var _date_resident;
  var _date_visiteur;
  var _date_handi;
  var _immat;

  double _speed = 0.00;
  double _speedAccuracy = 0.00;

  int selectedIndex = 0;
  int selectedIndex2 = 2;

  List<LatLng> polygon2 = [];

  // Test avec polygone Ville de Paris : 8F, 8H, 8K et 8K
  // String  coords =  "[[2.349523152241182, 48.885278809553235], [2.3495285520968, 48.88547162873088], [2.349560677931211, 48.88644917171378], [2.3495658690495462, 48.886505221696126], [2.349578931838315, 48.88725856604959], [2.34960309573548, 48.88747715627135], [2.349597537530851, 48.88830001919799], [2.351356026302531, 48.88824381388984], [2.351534771747939, 48.88823919814372], [2.35165225338608, 48.88825032316442], [2.353576236156508, 48.88842265802794], [2.354592718225991, 48.888513816420854],  [2.349485161693332, 48.88380127772563], [2.349492389999587, 48.88407705402098], [2.349494228820298, 48.88416673700776], [2.349501440078387, 48.88443242354842], [2.3495213536166633, 48.885216032076244], [2.349523152241182, 48.885278809553235]]";

  GeoPosition? userPosition;

  late googlemaps.GoogleMapController googleMapController;

  /// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///
  ///  we have 3 categories of vehicules
  ///
  /// 1 - vehicule "recent" and the user has an account to the car manufacturer API and has bluetooth connection active
  ///
  ///     bluetooth = 1 & econnect = 1
  ///
  ///     No need to watch in background if the user is or not in the car and where the car is parked
  ///
  ///     Just need to test when bluetooth is connected with the bluetooth of the car  to know that the user is in the car and so that we display speed, speed limitation and speed camera
  ///
  ///
  ///
  ///  2 - vehicule "middle recent" and the account with the car manufacturer API do not give car parked information but the user has bluetooth connection active
  ///
  ///     bluetooth = 1 & econnect = 0
  ///
  ///     No need to watch in background if the user is or not in the car and where the car is parked
  ///
  ///     Just need to test when bluetooth is connected with the bluetooth of the car  to know that the user is in the car and so that we display speed, speed limitation and speed camera
  ///     and to get the place parked ( = blutooth connexion just disconneted )
  ///
  ///
  ///
  ///  3 - vehicule "old" with no account to the car manufacturer API and no bluetooth AND/OR for user who do not want to use bluetooth
  ///
  ///     bluetooth = 0 & econnect = 0
  ///
  ///     We need to watch in background if the user is or not in the car and where the car is parked
  ///
  /// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /// --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ///
  /// BEGIN : activity recognition
  ///
  ///

  final activityRecognition = FlutterActivityRecognition.instance;
  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  final speedNotifier = ValueNotifier<double>(10);
  GlobalKey<KdGaugeViewState> guagekey = GlobalKey<KdGaugeViewState>();

  ///
  /// END : activity recognition
  ///

  ///
  /// BEGIN : Geofence
  ///

  final _geofencestreamController = StreamController<PolyGeofence>();

  // Create a [PolyGeofenceService] instance and set options.
  final _polyGeofenceService = poly_geofence.PolyGeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      allowMockLocations: false,
      printDevLog: false);

// Create a [PolyGeofence] list.
  late var _polyGeofenceList;

  ///
  /// END : Geofence
  ///

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Subscribe to the geofence service
      _polyGeofenceService
          .addPolyGeofenceStatusChangeListener(_onPolyGeofenceStatusChanged);
      _polyGeofenceService.addLocationChangeListener(_onLocationChanged);
      _polyGeofenceService.addLocationServicesStatusChangeListener(
          _onLocationServicesStatusChanged);
      _polyGeofenceService.addStreamErrorListener(_onError);
      _polyGeofenceService.start(_polyGeofenceList).catchError(_onError);

      // Subscribe to the activity stream.
      final activityRecognition = FlutterActivityRecognition.instance;

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });

    if (CarState == 99) {
      _lat = widget.lat as double;
      _lon = widget.lon as double;
      _adr = widget.LastAdresse as String;
    }

    // _lat = loc?.latitude ?? 48.873821;
    _plate = widget.immatriculation as String;
    _econnect = widget.econnect.toString();
    _zone = widget.residential_zone as String;

    _date_resident = widget.expResident as String;
    _date_visiteur = widget.expVisiteur as String;
    _date_handi = widget.expHandi as String;

    print('-------------------------dates--------------');
    print("_date_resident : $_date_resident");

    _plate = widget.immatriculation ?? ".";

    polygon2 = parseLatLng(_zone);

    // Map LatLng from google_maps_flutter to LatLng from poly_geofence_service
    List<poly_geofence.LatLng> polyGeofenceLatLng = polygon2
        .map((point) => poly_geofence.LatLng(point.latitude, point.longitude))
        .toList();

    _polyGeofenceList = <poly_geofence.PolyGeofence>[
      poly_geofence.PolyGeofence(
        id: '1',
        data: {},
        polygon: polyGeofenceLatLng,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;

    //   print("_date_resident : $_date_resident");
    //   print("_date_visiteur : $_date_visiteur");
    //   print("_date_handi : $_date_handi");

    _date_resident = widget.expResident as String;
    _date_visiteur = widget.expVisiteur as String;
    _date_handi = widget.expHandi as String;

    var platform = Theme.of(context).platform;

    GlobalKey<KdGaugeViewState> key = GlobalKey<KdGaugeViewState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillStartForegroundTask(
        onWillStart: () async {
          return _polyGeofenceService.isRunningService;
        },
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'geofence_service_notification_channel',
          channelName: 'Geofence Service Notification',
          channelDescription:
              'This notification appears when the geofence service is running in the background.',
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
          body: Column(
            children: [
              SizedBox(
                height: _height - 148,
                width: _width,
                child: IndexedStack(
                    alignment: Alignment.center,
                    index: this.selectedIndex,
                    children: <Widget>[
                      screen1_parking_State0(),
                      screen1_parking_State1(),
                      screen1_parking_State2(),
                    ]),
              ),
            ],
          ),
          /*
          floatingActionButton: FloatingActionButton(
            backgroundColor: color_background2,
            child: Text("Next"),
            onPressed: () {
              setState(() {
                if (this.selectedIndex < 2) {
                  this.selectedIndex++;
                } else {
                  this.selectedIndex = 0;
                }
              });
            },
          ),
          */
        ),
      ),
    );
  }

  List<LatLng> parseLatLng(String jsonString) {
    var json = jsonDecode(jsonString);
    return (json as List).map((item) => LatLng(item[0], item[1])).toList();
  }

  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  ///* -------------------------------------------------------------------------
  ///
  /// activity recognition
  ///
  /// --------------------------------------------------------------------------

  Future<void> _onActivityReceive(Activity activity) async {
    dev.log('Activity Detected >> ${activity.toJson()}');
    _activityStreamController.sink.add(activity);

    print(
        '-----------------------activity.type.toString------------------------------------------');
    print(activity.type.toString());
    print(
        '-----------------------activity.type.toString------------------------------------------');

    ///
    /// perhaps have to add in the future a test of condident = HIGH or > 80 ??
    ///
    switch (activity.type) {
      case ActivityType.IN_VEHICLE:
        activityType = 'En voiture';
        CarState = 1;
        break;
      case ActivityType.ON_BICYCLE:
        activityType = 'À vélo';
        CarState = 1;
        break;
      case ActivityType.STILL:
        activityType = 'Immobile';
        (CarState == 1) ? CarState = 1 : CarState = 0;
        break;
      case ActivityType.WALKING:
        activityType = 'Marche';
        (CarState == 1) ? CarState = 2 : CarState = 0;
        break;
      case ActivityType.RUNNING:
        activityType = 'Course';
        (CarState == 1) ? CarState = 2 : CarState = 0;
        break;
      case ActivityType.UNKNOWN:
        activityType = 'Inconnue';
        (CarState == 1) ? CarState = 1 : CarState = 0;
        break;
    }

    switch (CarState) {
      case 0:
        break;

      case 1:

        /// the user is in a car on a bicycle
        ///
        /// we display Screen2_road.dart

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen2_road()));
        break;

      case 2:

        /// the vehicule is just park
        /// we tacke location and DateTime
        /// and we show screen1_parking_State1
        ///

        /// get the location
        //  final loc = await LocationService().getPosition();

        // _lat = loc?.latitude ?? 48.873821;
        // _lon = loc?.longitude ?? 2.315757;

        /// get the adresse
        ///
        if (_lat != null) {
          List<geocoding.Placemark> placemarks =
              await geocoding.placemarkFromCoordinates(_lat, _lon);
          _adr = placemarks.reversed.last.street.toString() +
              " - " +
              placemarks.reversed.last.postalCode.toString() +
              " - " +
              placemarks.reversed.last.locality.toString();
        }

        (_adr != null) ? _adr : "Adresse inconnue";
        _tim = DateTime.now().toString();

        /// save the information in nosql database on the smartphone
        ///
        await DatabaseClient().VehiculeUpdateLoc(
            idKey: 1, lat: _lat, lon: _lon, adr: _adr, datetime: _tim);

        /// updtating the position on the map
        ///
        LatLng newlatlang = LatLng(_lat, _lon);
        googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newlatlang, zoom: 17)));

        /// we display screen1_parking_State1 (Index = 2)
        ///
        this.selectedIndex = 2;
        setState(() {
          screen1_parking_State1();
        });
        break;

      case 99:
        break;
    }
  }

  void _handleError(dynamic error) {
    dev.log('Catch Error >> $error');
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  ///* -------------------------------------------------------------------------
  ///
  /// Management of the geolocation / zoning and speed detector
  ///
  /// --------------------------------------------------------------------------

  // This function is to be called when the geofence status is changed.
  Future<void> _onPolyGeofenceStatusChanged(
      PolyGeofence polyGeofence,
      poly_geofence.PolyGeofenceStatus polyGeofenceStatus,
      poly_geofence.Location location) async {
    //  print('polyGeofence: ${polyGeofence.toJson()}');
    //  print('polyGeofenceStatus: ${polyGeofenceStatus.toString()}');
    _geofencestreamController.sink.add(polyGeofence);
    //  print('------------------------------------------------');
    //  print('Geofence Status: ${polyGeofenceStatus.toString()}');
    //  print('------------------------------------------------');

    setState(() {
      switch (polyGeofenceStatus) {
        case poly_geofence.PolyGeofenceStatus.ENTER:
          // (inpolygeofence == 0) ? inpolygeofence = 0 : inpolygeofence = 2;
          inpolygeofence = 0;
          break;
        case poly_geofence.PolyGeofenceStatus.DWELL:
          // (inpolygeofence == 0) ? inpolygeofence = 0 : inpolygeofence = 2;
          // inpolygeofence = 1;
          break;
        case poly_geofence.PolyGeofenceStatus.EXIT:
          // (inpolygeofence == 0) ? inpolygeofence = 0 : inpolygeofence = 2;
          inpolygeofence = 2;
          break;
      }
    });
  }

  // This function is to be called when the location has changed.
  void _onLocationChanged(poly_geofence.Location location) {
    //  print('location: ${location.toJson()}');
    if (CarState != 99)
      setState(() {
        (location.speed < 5) ? _speed = 0 : _speed = location.speed * 3.6;
        _speedAccuracy = location.speedAccuracy;
        _lat = location.latitude;
        _lon = location.longitude;
        guagekey.currentState?.updateSpeed(_speed);

        //   Container_Speedometer();
        Container_GMaps_ZoneResidentielle();
        Container_GMaps();
      });
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
  void disposeGeofence() {
    poly_geofence.PolyGeofenceService.instance.clearAllListeners();
    poly_geofence.PolyGeofenceService.instance.stop();
    super.dispose();
  }

  ///* -------------------------------------------------------------------------
  ///
  ///
  ///
  /// --------------------------------------------------------------------------

  @override
  void disposeActivity() {
    _activityStreamController.close();
    //  _activityStreamSubscription?.cancel();
    super.dispose();
  }

  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///
  ///                            S C R E E N S
  ///
  /// --------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------

  /// this screen1_parking is composed with 3 différents sub screens :
  ///
  /// screen1_parking_State0 : "home screen" with the last parking place and check informations"
  /// screen1_parking_State1 : "vehicule is on the road : speedometer and check speed limitations and speed camera"
  /// screen1_parking_State2 : "vehicule just parked, control if the vehicule is inside or outside his residential zone or his private park"
  ///
  ///
  /// the screen change automaticaly depending the speed of vehicule activity recongnition

  ///*
  /// screen1_parking_State0 : "home page" with the last parking place and check informations"
  ///

  screen1_parking_State0() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: _height - 40,
      width: _width,
      child: Column(
        children: [
          Container_Entete(),
          Container_GMaps(),
          Container_CheckControl(),
        ],
      ),
    );
  }

  ///*
  /// screen1_parking_State1 : "vehicule just parked, control if the vehicule is inside or outside his residential zone or his private park"
  ///

  screen1_parking_State1() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: _height - 10,
      width: _width,
      child: Column(
        children: [
          Container_Entete(),
          Container_GMaps(),
          Container_Stationnement(),
        ],
      ),
    );
  }

  ///*
  /// screen1_parking_State2 : this screen is only to display the residential zone of the car if the use want to see it"
  ///

  screen1_parking_State2() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: _height - 10,
      width: _width,
      child: Column(
        children: [
          Container_Entete_ZoneResidentielle(),
          Container_GMaps_ZoneResidentielle(),
          Container_lower_ZoneResidentielle(),
        ],
      ),
    );
  }

  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///
  ///                         S U B    S C R E E N S
  ///
  /// --------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------

  Container_Entete() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: 95,
      width: _width,
      decoration: BoxDecoration(
        color: color_background,
        border: Border.all(color: color_border),
        borderRadius: BorderRadius.circular(border_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 2.0),
          Text("Véhicule : $_plate", style: TextStyle_regular),
          SizedBox(height: 2.0),
          Text(
              (CarState == 2)
                  ? "Vous venez de vous garer à proximité de"
                  : "Votre dernier stationnement",
              style: TextStyle_regular),
          SizedBox(height: 2.0),
          Text(_adr.toString() ?? "", style: TextStyle_regular),
        ],
      ),
    );
  }

  Container_GMaps() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: _height - 495,
      width: _width,
      child: ParkingMap(
        LatitudeLongitude(
          _lat ?? 48.873821,
          _lon ?? 2.315757,
        ),
      ),
    );
    /* return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: _height - 495,
      width: _width,
      decoration: BoxDecoration(
        color: color_background,
        border: Border.all(color: color_border),
        borderRadius: BorderRadius.circular(border_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat! as double, _lon! as double),
          zoom: 17,
        ),
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        myLocationEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
          ),
        },
        circles: Set.from(
          [
            Circle(
              circleId: CircleId('currentCircle'),
              center: LatLng(_lat! as double, _lon! as double),
              radius: 30,
              fillColor: Colors.blue.shade100.withOpacity(0.5),
              strokeWidth: 2,
              strokeColor: Colors.red.withOpacity(1),
            ),
          ],
        ),
        polygons: {
          Polygon(
            polygonId: PolygonId("1"),
            points: polygon2,
            fillColor: Color(0xFF006491).withOpacity(0.2),
            strokeWidth: 1,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            googleMapController = controller;
          });
        },
      ),
    ); */
  }

  Container_CheckControl() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: 215,
      decoration: BoxDecoration(
        color: color_background,
        border: Border.all(color: color_border),
        borderRadius: BorderRadius.circular(border_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text("Check Control", style: TextStyle_regular),
          Divider(),
          Container(
            height: 95,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PayByPhoneBrowser(
                                      immatriculation: _plate,
                                      categoriepayment: "Résidentiel")));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.squareParking,
                                size: 48, color: Colors.green),
                            Text("Résidentiel",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PayByPhoneBrowser(
                                      immatriculation: _plate,
                                      categoriepayment: "Visiteur")));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.squareParking,
                                size: 48, color: Colors.green),
                            Text("Payant",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => list_amendes()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.fileInvoiceDollar,
                                size: 43, color: Colors.green),
                            Text("FPS",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => list_amendes()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.fileInvoiceDollar,
                                size: 43, color: Colors.redAccent),
                            Text("Amendes",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const mespapiers()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.fileInvoice,
                                size: 43, color: Colors.green),
                            Text("Documents",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => list_amendes()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.car_rental,
                                size: 43, color: Colors.redAccent),
                            Text("Controle",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 90,
                  color: Colors.grey.shade200,
                  child: SizedBox.fromSize(
                    size: Size(85, 85),
                    child: Material(
                      color: color_background,
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => list_amendes()),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.car_repair,
                                size: 43, color: Colors.redAccent),
                            Text("Révision",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            //    crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 38,
                width: _width - 80,
                decoration: BoxDecoration(
                    color: color_background,
                    border: Border.all(
                      color: color_background,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextButton(
                  child: Text("Cliquez ici si vous avez reçu une amende",
                      style: TextStyle_verysmall),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AmendesScanner()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///*
  /// Lower Container Stationnement
  ///
  /// This Container should be put in another dart file so me ( Pierre-Jean) could work on it
  ///

  Container_Stationnement() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
      height: 218,
      width: _width,
      decoration: BoxDecoration(
        color: color_background,
        border: Border.all(color: color_border),
        borderRadius: BorderRadius.circular(border_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Divider(height: 10),
          (inpolygeofence == 0)
              ? Column(
                  children: [
                    Divider(height: 10),
                    Text('Vous êtes dans votre zone résidentielle',
                        style: TextStyle_regular),
                    Divider(height: 10),
                    Text('votre stationnement est payé',
                        style: TextStyle_regular),
                    Divider(height: 10),
                    Text("Vous n'avez rien à faire", style: TextStyle_regular),
                    Divider(height: 10),
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        size: 36,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DevEnCours()),
                        );
                      },
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(height: 10),
                    Text('Vous êtes hors de votre zone résidentielle',
                        style: TextStyle_small),
                    Divider(height: 10),
                    Container(
                      height: 40,
                      width: _width - 80,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                            color: color_background,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: TextButton(
                        child: Text(
                            "Cliquez ici pour payer votre stationnement",
                            style: TextStyle_verysmall),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => webview2(
                                  url:
                                      "https://m2.paybyphone.fr/parking/start/location",
                                  title: "PayByPhone"),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(height: 10),
                    Container(
                      height: 40,
                      width: _width - 80,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: color_background,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: TextButton(
                        child: Text("Cliquez ici pour déclencher un minuteur",
                            style: TextStyle_verysmall),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountDownTimer()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Container_Entete_ZoneResidentielle() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(2),
      height: 45,
      width: _width,
      /*
      decoration: BoxDecoration(
        color: color_background,
        border: Border.all(color: color_border),
        borderRadius: BorderRadius.circular(border_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
       */
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Votre Zone résidentielle", style: TextStyle_large),
        ],
      ),
    );
  }

  Container_GMaps_ZoneResidentielle() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: (_height - 290),
      width: _width,
      decoration: BoxDecoration(
        color: color_background,
        border: Border.all(color: color_border),
        borderRadius: BorderRadius.circular(border_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat! as double, _lon! as double),
          zoom: 13.7,
        ),
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        myLocationEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        circles: Set.from(
          [
            Circle(
              circleId: CircleId('currentCircle'),
              center: LatLng(_lat! as double, _lon! as double),
              radius: 30,
              fillColor: Colors.blue.shade100.withOpacity(0.5),
              strokeWidth: 2,
              strokeColor: Colors.red.withOpacity(1),
            ),
          ],
        ),
        polygons: {
          Polygon(
            polygonId: PolygonId("1"),
            points: polygon2,
            fillColor: Color(0xFF006491).withOpacity(0.2),
            strokeWidth: 1,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            googleMapController = controller;
          });
        },
      ),
    );
  }

  ///*
  /// Lower Container Zone Residentielle
  ///

  Container_lower_ZoneResidentielle() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: 60,
      width: _width,
      /*
        decoration: BoxDecoration(
          color: color_background,
          border: Border.all(color: color_border),
          borderRadius: BorderRadius.circular(border_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
         */
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 40,
            width: _width - 80,
            decoration: BoxDecoration(
                color: color_background2,
                border: Border.all(
                  color: color_background,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextButton(
              child: Text("Retour à l'écran précédent",
                  style: TextStyle_regular_white),
              onPressed: () {
                this.selectedIndex = 0;
                setState(() {
                  // screen1_parking_State1();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
