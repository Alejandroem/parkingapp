// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:mycar/widgets/location_search.dart';
import 'package:mycar/widgets/parking_browser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import '../databases/databases.dart';
import 'application/cubits/location_cubit.dart';
import 'domain/models/user_locations.dart';
import 'domain/services/directions_service.dart';
import 'widgets/navigation_map.dart';

// void main() => runApp(const MaterialApp(home: screen2_road()));

class screen2_road extends StatefulWidget {
  const screen2_road({super.key, this.androidDrawer, this.lat, this.lon});

  final Widget? androidDrawer;
  final double? lat;
  final double? lon;

  @override
  State<screen2_road> createState() => screen2_roadState();
}

class screen2_roadState extends State<screen2_road> {
  // late final WebViewController _controller;

  var _width;
  var _height;

  var CarParkingGeolocalisation;
  var CarParkingAdresse;
  var CarParkingDateTime;
  var CarSpeed = 0.00;
  var CarState = 99;
  var inpolygeofence = 99;
  var _radar = 0;

  bool _alarmSpeed = true;
  bool _alarmCameraSpeed = true;

  Future<void>? _launched;
  String _plate = "";
  String _econnect = "";

  var _lat;
  var _lon;
  var _adr;
  var _tim;
  var _zone;
  var _date_resident;
  var _date_visiteur;
  var _date_handi;
  var _immat;
  var previousActivity;
  var actualActivity;
  var currentActivity;
  var activityType;

  double _speed = 0.00;
  double _speedAccuracy = 0.00;

  int selectedIndex = 0;
  int selectedIndex2 = 2;

  List<LatLng> polygon2 = [];

  // variables to change the color of the 2 change order icons
  bool colorTwo = false, colorThree = false;

  final speedNotifier = ValueNotifier<double>(10);
  GlobalKey<KdGaugeViewState> guagekey = GlobalKey<KdGaugeViewState>();

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

  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
    // isInspectable: kDebugMode,
    // mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    javaScriptCanOpenWindowsAutomatically: true,
  );

  PullToRefreshController? pullToRefreshController;

  //late ContextMenu contextMenu;

  double progress = 0;

  final urlController = TextEditingController();

  /// activity recognition
  final activityRecognition = FlutterActivityRecognition.instance;
  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Subscribe to the activity stream.
      final activityRecognition = FlutterActivityRecognition.instance;

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });

    _lat = widget.lat as double;
    _lon = widget.lon as double;
  }

  GoogleMapController? _controller;
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;

    var platform = Theme.of(context).platform;

    return BlocListener<LocationCubit, UserLocation>(
      listener: (context, state) {
        log('listener: $state');
        if (state.currentLocation != null && state.lastTappedLocation != null) {
          _mapController.buildRoute(
            wayPoints: [
              WayPoint(
                name: "Start",
                latitude: state.currentLocation!.latitude,
                longitude: state.currentLocation!.longitude,
              ),
              WayPoint(
                name: "End",
                latitude: state.lastTappedLocation!.latitude,
                longitude: state.lastTappedLocation!.longitude,
              ),
            ],
          );
        }
      },
      child: Stack(
        children: [
          Screen_freeNav(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 32, 100, 8),
            child: TextField(
              onTap: () async {
                String? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSearch(),
                  ),
                );
                if ((result ?? "").isNotEmpty) {
                  _locationController.text = result!;
                } else {
                  _locationController.clear();
                }
              },
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter destination',
                //border color white
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                //add a button to clean this at the end
                suffixIcon: IconButton(
                  onPressed: () {
                    _locationController.clear();
                    _mapController.clearRoute();
                    _mapController.startFreeDrive();
                    //hide keyboard
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    /* child: Scaffold( 
        body: SafeArea(
          child: DefaultTabController(
            length: 4,
            child: Column(
              children: <Widget>[
                /* Container(
                  color: color_background2,
                  height: 40,
                  width: _width,
                  child: Center(
                    child: ButtonsTabBar(
                      backgroundColor: color_background2,
                      unselectedBackgroundColor: color_background2,
                      unselectedLabelStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                      labelStyle: TextStyle(
                          color: Colors.yellow, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(
                          icon: Icon(FontAwesomeIcons.road, size: 18),
                          //  text: "Dest.",
                        ),
                        Tab(
                          icon: Icon(FontAwesomeIcons.google, size: 18),
                          // text: "Google",
                        ),
                        Tab(
                          icon: Icon(FontAwesomeIcons.waze, size: 18),
                          //   text: "Waze",
                        ),
                        Tab(
                          icon: Icon(FontAwesomeIcons.car, size: 18),
                          //  text: "Traffic",
                        ),
                      ],
                    ),
                  ),
                ), */
                
                /* Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Center(
                        child: Screen_freeNav(),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "A T T E N T I O N",
                              style: TextStyle_large,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "En cliquant sur le bouton ci-dessous\nVous serez redidrigé\nvers l'application Google Map",
                              style: TextStyle_small,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 200.0,
                              height: 100.0,
                              child: ElevatedButton(
                                child: Text("Google Maps",
                                    style: TextStyle_regular_white),
                                style: ElevatedButton.styleFrom(
                                  primary: color_background2,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  GMaps();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "A T T E N T I O N",
                              style: TextStyle_large,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "En cliquant sur le bouton ci-dessous\nVous serez redidrigé\nvers l'application Waze",
                              style: TextStyle_small,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 200.0,
                              height: 100.0,
                              child: ElevatedButton(
                                child:
                                    Text("Waze", style: TextStyle_regular_white),
                                style: ElevatedButton.styleFrom(
                                  primary: color_background2,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Waze();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Screen_Traffic(),
                      ),
                    ],
                  ),
                ), */
              ],
            ),
          ),
        ),
      ),
    );*/
  }

  late MapBoxNavigationViewController _mapController;

  Screen_freeNav() {
    MapBoxOptions options = MapBoxNavigation.instance.getDefaultOptions();
    options.language = "fr";
    options.units = VoiceUnits.metric;
    options.initialLatitude = 48.8955025;
    options.initialLongitude = 2.368245;
    options.zoom = 18.0;

    return MapBoxNavigationView(
      options: options,
      onRouteEvent: (value) {
        print('RouteEvent: $value');
      },
      onCreated: (MapBoxNavigationViewController controller) async {
        _mapController = controller;
        controller.initialize();
        await controller.startFreeDrive(
          options: options,
        );
      },
    );
  }

  Screen_Navto() {}

  Screen_Traffic() {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      height: _height - 125,
      width: _width,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat, _lon),
          //target: LatLng(48.88246946770146,2.3078547543281744), // Paris 8e
          zoom: 11.0,
        ),
        trafficEnabled: true, // Enable traffic data
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
      ),
    );
  }

  ///* -------------------------------------------------------------------------
  ///
  /// Activity Recognition to determine if the user is on the road in a vehicule or if he juste left it and walk
  ///
  /// to stop all activties on theis screen and display Screen1_parking.dart
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
    /// todo : add a test on the confident level (= HIGH or > 80 ? )
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

        /// user is in his car and the car started
        break;

      case 2:

        /// the vehicule just stop and we take the location, save it and we display screen1_parking

        /// get the localisation
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

        /// save the location in the database
        ///
        await DatabaseClient().VehiculeUpdateLoc(
            idKey: 1, lat: _lat, lon: _lon, adr: _adr, datetime: _tim);

        /// as the vehicule is parked we display Screen1_Parking with map and informations of payment
        ///
        //Navigator.push(
        // context,
        // MaterialPageRoute(builder: (context) => screen1_parking()));
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
    _mapController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  @override
  void disposeActivity() {
    _activityStreamController.close();
    //  _activityStreamSubscription?.cancel();
    super.dispose();
  }

  void GMaps() {
    _launchUniversalLinkIos(
      Uri(
          scheme: 'https',
          host: 'www.google.com',
          path:
              '/maps/search/?api=1&query=47.48.88246946770146%2.307854754328'),
    );
  }

  void Waze() {
    _launchUniversalLinkIos(
      Uri(
          scheme: 'https',
          host: 'waze.com',
          path:
              '/ul?ll=48.88246946770146,2.3078547543281744&navigate=yes&zoom=17'),
    );
  }

  Screen_Maps(double Lat, double Lon) {
    /// in my code :
    // String url = "https://www.google.com/maps/@$Lat,$Lon,10z/data=!5m1!1e1?entry=ttu";

    /// for you to test
    //   String url = "https://www.google.com/maps/@48.88246946770146,2.3078547543281744,10z/data=!5m1!1e1?entry=ttu";

    String url =
        "https://www.google.com/maps/@48.88246946770146,2.3078547543281744,15";

    return Expanded(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url!)),
        initialSettings: settings,

        pullToRefreshController: pullToRefreshController,

        onWebViewCreated: (controller) async {
          webViewController = controller;
        },

        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT);
        },

        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (![
            "http",
            "https",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri.scheme)) {
            if (await canLaunchUrl(uri)) {
              // Launch the App
              await launchUrl(
                uri,
              );
              // and cancel the request
              return NavigationActionPolicy.CANCEL;
            }
          }
          return NavigationActionPolicy.ALLOW;
        },

        onLoadStart: (controller, url) async {
          setState(() {
            urlController.text = url as String;
          });
        },

        // onEnterFullscreen:
        // onFindResultReceived
        // onWebContentProcessDidTerminate
        // onLoadResourceWithCustomScheme

        onLoadStop: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            urlController.text = url as String;
          });
          var html = await controller.evaluateJavascript(
              source: "window.document.body.innerText");
        },

        onRenderProcessGone: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            urlController.text = url as String;
          });
          var html = await controller.evaluateJavascript(
              source: "window.document.body.innerText");
        },

        onLoadResourceWithCustomScheme: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            urlController.text = url as String;
          });
          var html = await controller.evaluateJavascript(
              source: "window.document.body.innerText");
        },

        onPageCommitVisible: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            urlController.text = url as String;
          });
          var html = await controller.evaluateJavascript(
              source: "window.document.body.innerText");
        },

        onTitleChanged: (controller, url) async {
          pullToRefreshController?.endRefreshing();
          controller
              .evaluateJavascript(source: "window.document.body.innerText")
              .then((html) {
            (html.contains("Stationnement"))
                ? {
                    print('---------------------3----------------------'),
                    print(html)
                  }
                : print(
                    "-----------------------/ onTitleChanged /-----------------");
            // var source = "window.top.document.body.innerHTML" ;
            //print(source);
          });
        },

        onProgressChanged: (controller, url) {
          if (progress == 100) {
            pullToRefreshController?.endRefreshing();
            controller
                .evaluateJavascript(source: "window.document.body.innerText")
                .then((html) {
              print(
                  "-----------------------onProgressChanged-------------------");
              print(html);
            });
          }
          setState(() {
            this.progress = progress / 100;
            urlController.text = url as String;
          });
        },

        onReceivedError: (controller, request, error) {
          pullToRefreshController?.endRefreshing();
          print('------------error------------------');
          print(error);
        },
      ),
    );
    return;
  }
}
