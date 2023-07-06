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
import 'package:kdgaugeview/kdgaugeview.dart';

import 'package:alxgration_speedometer/speedometer.dart';
import 'package:mycar/services/webview.dart';

import 'package:poly_geofence_service/poly_geofence_service.dart' as poly_geofence;
import 'package:poly_geofence_service/models/poly_geofence.dart';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';



import '../constants.dart';
import '../services/webview2.dart';
import '../databases/DatabaseClient.dart';
import '../drawerscreens/mespapiers.dart';
import '../drawerscreens/dev_en_cours.dart';
import '../errors/error_codes.dart';
import '../services/count-down_timer.dart';
import '../services/location_service.dart';
import '../antai/list_amendes.dart';
import '../antai/antai.dart';

class screen1 extends StatefulWidget {
  const screen1(
      {super.key,
        this.androidDrawer,
        this.lat,
        this.lon,
        this.isInZone,
        this.CurrentActivity,
        this.LastDateTimeParking,
        this.LastAdresse,
        this.residential_zone});

  final Widget? androidDrawer;
  final double? lat;
  final double? lon;
  final int? isInZone;
  final String? residential_zone;
  final int? CurrentActivity;
  final String? LastDateTimeParking;
  final String? LastAdresse;

  @override
  State<screen1> createState() => screen1State();
}

class screen1State extends State<screen1> {
//  const screen1({super.key});

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

  var _lat;
  var _lon;
  var _adr;
  var _tim;
  var _width;
  var _height;
  var _zone;

  bool _alarmSpeed = true;
  bool _alarmCameraSpeed = true;

  var _radar = 0;

  double _speed = 0.00;
  double _speedAccuracy = 0.00;

  int selectedIndex = 0;
  int selectedIndex2 = 2;

  Future<void>? _launched;

  List<LatLng> polygon2 = [];

  // Test avec polygone Ville de Paris : 8F, 8H, 8K et 8K
  // String  coords =  "[[2.349523152241182, 48.885278809553235], [2.3495285520968, 48.88547162873088], [2.349560677931211, 48.88644917171378], [2.3495658690495462, 48.886505221696126], [2.349578931838315, 48.88725856604959], [2.34960309573548, 48.88747715627135], [2.349597537530851, 48.88830001919799], [2.351356026302531, 48.88824381388984], [2.351534771747939, 48.88823919814372], [2.35165225338608, 48.88825032316442], [2.353576236156508, 48.88842265802794], [2.354592718225991, 48.888513816420854],  [2.349485161693332, 48.88380127772563], [2.349492389999587, 48.88407705402098], [2.349494228820298, 48.88416673700776], [2.349501440078387, 48.88443242354842], [2.3495213536166633, 48.885216032076244], [2.349523152241182, 48.885278809553235]]";

  GeoPosition? userPosition;

  late googlemaps.GoogleMapController googleMapController;

  ///*
  /// Début mise en place gestion activity recognition
  ///
  ///

  final activityRecognition = FlutterActivityRecognition.instance;
  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  final speedNotifier = ValueNotifier<double>(10);
  final key = GlobalKey<KdGaugeViewState>();

  ///*
  /// Fin Mise en place gestion activity recognition
  ///

  ///*
  /// Début mise en place gestion Geofence
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

  ///*
  /// Fin mise en place gestion Geofence
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

    _zone = widget.residential_zone;

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
                width: _width,
                height: _height - 145,
                child: IndexedStack(
                    alignment: Alignment.center,
                    index: this.selectedIndex,
                    children: <Widget>[
                      Screen1_State0(),
                      Screen1_State1(),
                      Screen1_State2(),
                      Screen1_State3(),
                    ]),
              ),
            ],
          ),
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
  /// Gestion du detecteur d'activité
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
    /// ajouter un test sur le niveau de confiance (condident = HIGH ou > 80 ??
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

      /// l'utilisateur est dans un vehicule ou un velo
      ///
      /// on affiche l'ecran Screen2

        this.selectedIndex = 1;
        setState(() {
          Screen1_State1();
        });
        break;

      case 2:

      /// le véhicule vient d'être stationné
      /// on prend, on mémorise l'emplacement
      /// et on affiche l'écran suivant
      /// avec la carte de l'emplacement

      /// récupération de la localisation
      //  final loc = await LocationService().getPosition();

      // _lat = loc?.latitude ?? 48.873821;
      // _lon = loc?.longitude ?? 2.315757;

      /// recuperation de l'adresse
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

        /// enregistrement de la localisation dans la base de données
        ///
        await DatabaseClient().VehiculeUpdateLoc(
            idKey: 1, lat: _lat, lon: _lon, adr: _adr, datetime: _tim);

        /// Actualisation de la position sur la carte
        ///
        LatLng newlatlang = LatLng(_lat, _lon);
        googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newlatlang, zoom: 17)));

        /// affichage Screen1_State2 (Index = 2)
        ///
        this.selectedIndex = 2;
        setState(() {
          Screen1_State2();
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
  /// Gestion du detecteur de geolocalisation / zonage et vitesse
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
        (location.speed < 5)
            ? _speed = 0
            : _speed = location.speed * 3.6;
        _speedAccuracy = location.speedAccuracy;
        _lat = location.latitude;
        _lon = location.longitude;
        key.currentState!.updateSpeed(_speed);

        Container_Speedometer();
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
  /// Gestion du detecteur d'activité
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
  ///                            Ecrans d'affichages
  ///
  /// --------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------
  ///* -------------------------------------------------------------------------

  /// this page is composed with 3 différents screen :
  ///
  /// Screen1_State0 : "home page with last parking place"
  /// Screen1_State1 : "behicule on the road : speedometer"
  /// Screen1_State2 : "vehicule just parked"
  ///
  ///
  /// the screen change automaticlaly / activity recongnition

  ///*
  /// Screen1_State0 : ecran d'accueil / véhicule à l'arret
  ///

  Screen1_State0() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: _height - 10,
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
  /// Screen1_State1 : véhicule en route
  ///

  Screen1_State1() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: _height - 10,
      width: _width,
      child: Column(
        children: [
          Container_Speedometer(),
          Container_Speedometer_Control(),
        ],
      ),
    );
  }

  ///*
  /// Screen1_State2 : stationnement du véhicule
  ///

  Screen1_State2() {
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
  /// Screen1_State3 : ma Zone Résidentielle
  ///

  Screen1_State3() {
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

  Container_Entete() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: 100,
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
          SizedBox(height: 5.0),
          Text(
              (CarState == 2)
                  ? "Vous venez de vous garer à proximité de"
                  : "Votre dernier stationnement",
              style: TextStyle_regular),
          SizedBox(height: 5.0),
          Text(_adr.toString() ?? "", style: TextStyle_regular),
        ],
      ),
    );
  }

  Container_GMaps() {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(5),
      height: (_height / 2.4),
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
    );
  }

  Container_CheckControl() {
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(5),
        height: _height / 3 - 75,
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
        child: Column(children: [
          Text("Check Control", style: TextStyle_regular),
          Divider(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              //    crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox.fromSize(
                  size: Size(85, 85),
                  child: Material(
                    color: color_background,
                    child: InkWell(
                      splashColor: color_background2,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DevEnCours()),
                        );
                      },
                      child: InkWell(
                        splashColor: color_background2,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => webview2(url:"https://m2.paybyphone.fr/parking", title:"Paybyphone"),
                             ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.squareParking,
                                size: 48, color: Colors.green),
                            Text("Stationnement",
                                style: TextStyle_veryverysmall), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.fromSize(
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
                SizedBox.fromSize(
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
              ]),
          Divider(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              //    crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
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
                        MaterialPageRoute(builder: (context) => antai()),
                      );
                    },
                  ),
                ),
              ]),
        ]));
  }

  ///*
  /// Screen : Speedometer
  ///

  Container_Speedometer() {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      height: _height - 285,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [

          Text("Vous roulez à :", style: TextStyle_large),

          Container(
            width: 330,
            height: 330,
            padding: EdgeInsets.all(2),
            child: KdGaugeView(
              key: key,
              minSpeed: 5,
              maxSpeed: 200,
              speed: 10,
              animate: false,
              alertSpeedArray: [30, 50, 90],
              alertColorArray: [Colors.green, Colors.orange, Colors.red],
              duration: Duration(seconds: 1),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                height: 75,
                width: 110,
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

              child:
                Column(
                  children:
                      [
                  Switch(
                  // This bool value toggles the switch.
                  value: _alarmSpeed,
                  activeColor: color_background2,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      _alarmSpeed = value;
                    });
                  },
                ),
                        Text("Alarm Radar",
                        style: TextStyle_small),
                      ]

                ),
               ),

              Container(
                height: 120,
                width: 120,
                child:
                ( _radar == 0 )
                    ? CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.red,
                            child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.white,
                                  child:Text( "50", // _speed.toString(),
                                      style: TextStyle_verylarge)
                            ),
                        )

                    : IconButton(
                          icon: Image.asset('assets/images/radar200.png'),
                          iconSize: 100,
                          onPressed: () {},
                        ),

              ),

              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                height: 75,
                width: 110,
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

                child:
                Column(
                    children:
                    [
                      Switch(
                        // This bool value toggles the switch.
                        value: _alarmCameraSpeed,
                        activeColor: color_background2,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            _alarmCameraSpeed = value;
                          });
                        },
                      ),
                      Text("Alarm Vitesse",
                          style: TextStyle_small),
                    ]

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container_Speedometer_Control() {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(0),
        height: 100,
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: _width / 2 - 50,
                          height: 65,
                          decoration: BoxDecoration(
                              color: (inpolygeofence == 0)
                                  ? Colors.green
                                  : Colors.red,
                              border: Border.all(
                                color: color_background,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: InkWell(
                            splashColor: color_background2,
                            onTap: () {
                              this.selectedIndex = 3;
                              setState(() {
                                Screen1_State1();
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.layerGroup,
                                    size: 30, color: Colors.white),
                                Text("Zone résidentielle",
                                    style: TextStyle_veryverysmall), // <-- Text
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: _width / 2 - 50,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                color: color_background,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: InkWell(
                            splashColor: color_background2,
                            onTap: () => setState(() {
                              _launched = _launchUniversalLinkIos(Uri(
                                  scheme: 'https',
                                  host: 'waze.com',
                                  path: '/ul'));
                            }),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.waze,
                                    size: 30, color: Colors.white),
                                Text("Waze",
                                    style: TextStyle_verysmall), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ));
  }

  ///*
  /// Lower Container Stationnement
  ///

  Container_Stationnement() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
      height: _height / 3 - 75,
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => webview2(
                          url: "https://m2.paybyphone.fr/parking/start/location",
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
                  Screen1_State1();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

