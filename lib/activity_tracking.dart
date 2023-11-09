// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

// import 'databases/databases.dart';


class activity_tracking_service {

  var previousActivity;
  var actualActivity;
  var currentActivity;
  var activityType;
  var CarState;
  var _adr;
  var _lat;
  var _lon;
  var _time;

  // variables to change the color of the 2 change order icons
  bool colorTwo = false, colorThree = false;


  double progress = 0;

  /// activity recognition
  final activityRecognition = FlutterActivityRecognition.instance;
  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // Subscribe to the activity stream.
      final activityRecognition = FlutterActivityRecognition.instance;

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });


    
  }


  ///* -------------------------------------------------------------------------
  ///
  /// Activity Recognition to determine if the user is on the road in a vehicule or if he juste left it and walk
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
      /// I would like that the function display screen2_road.dart
      /// but the following line make error
      // Navigator.push(context,MaterialPageRoute(builder: (context) => screen1_parking()));
        break;

      case 2:

      /// the vehicule just stop and we take the location, save it and we display screen1_parking

      /// we get the location
      //  final loc = await LocationService().getPosition();

      // _lat = loc?.latitude ?? 48.873821;
      // _lon = loc?.longitude ?? 2.315757;

      /// get the adress
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
        _time = DateTime.now().toString();

        /// save the location in the database ( I have comment here for you and I will un comment it after for me )
        ///
       //  await DatabaseClient().VehiculeUpdateLoc(idKey: 1, lat: _lat, lon: _lon, adr: _adr, datetime: _tim);

        /// as the vehicule is parked we display Screen1_Parking with map and informations of payment
        ///
        /// but the following line make error
        //Navigator.push(context,MaterialPageRoute(builder: (context) => screen1_parking()));
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
  }

  void onError(Object error) {
    print('ERROR - $error');
  }



}
