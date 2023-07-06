// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

import 'package:mycar/services/location_service.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'databases/DatabaseClient.dart';
import 'map/map_show.dart';
import '../constants.dart';
import '../text_FR.dart';
import 'databases/DatabaseClient.dart';
import 'databases/vehicules.dart';

class screen2 extends StatefulWidget {
  const screen2(
      {super.key,
      this.androidDrawer,
      this.lat,
      this.lon,
      this.isInZone,
      this.CurrentActivity});

  final Widget? androidDrawer;
  final double? lat;
  final double? lon;
  final int? isInZone;
  final int? CurrentActivity;

  @override
  State<screen2> createState() => screen2State();
}

class screen2State extends State<screen2> {
  // const screen2_parking({super.key});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    //print("size: $size");
    // print("platform: $platform");
    return Scaffold(
      body: SingleChildScrollView (

          child: Container(
            color: color_background2,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: (size.height / 5) - 60,
                        width: size.width,
                        color: color_background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Stationnement résidentiel ",
                                      style: TextStyle_regular_bold),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.green, // Button color
                                      child: InkWell(
                                        splashColor: Colors.red,
                                        onTap: () {},
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Icon(Icons.check,
                                                size: 25, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                ]),
                            Text("Payé jusqu'au samedi 2 mars à 14h52",
                                style: TextStyle_small),
                            Text("Cliquez ici pour prolonger",
                                style: TextStyle_regular_green),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: (size.height / 5) - 60,
                        width: size.width,
                        color: color_background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Stationnement Payant ",
                                      style: TextStyle_regular_bold),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.grey, // Button color
                                      child: InkWell(
                                        splashColor: Colors.red,
                                        onTap: () {},
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Icon(Icons.check,
                                                size: 25, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                ]),
                            Text(" ", style: TextStyle_small),
                            Text("Cliquez ici pour payer",
                                style: TextStyle_regular_grey),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: (size.height / 5) - 20,
                        width: size.width,
                        color: color_background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Amendes et FPS ", style: TextStyle_regular_bold),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.red, // Button color
                                      child: InkWell(
                                        splashColor: Colors.red,
                                        onTap: () {},
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Icon(Icons.check,
                                                size: 25, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                ]),
                            Text("Vous avez 2 FPS à payer",
                                style: TextStyle_small),
                            Text("Vous avez 1 Amende à payer",
                                style: TextStyle_small),
                            Text("Cliquez ici pour payer",
                                style: TextStyle_regular_green),
                          ],
                        )),

                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: (size.height / 5) - 20,
                        width: size.width,
                        color: color_background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Controle Téechnique ", style: TextStyle_regular_bold),
                                  ClipOval(
                                    child: Material(
                                      color: Colors.green, // Button color
                                      child: InkWell(
                                        splashColor: Colors.red,
                                        onTap: () {},
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Icon(Icons.check,
                                                size: 25, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                ]),
                            Text("Controle technique à faire avant le 23 juin",
                                style: TextStyle_small),
                            Text("Cliquez ici pour prendre rendez-vous",
                                style: TextStyle_regular_green),
                          ],
                        )),

                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: (size.height / 5) - 20,
                        width: size.width,
                        color: color_background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Révision véhicule ", style: TextStyle_regular_bold),

                                  ClipOval(
                                    child: Material(
                                      color: Colors.orange, // Button color
                                      child: InkWell(
                                        splashColor: Colors.red,
                                        onTap: () {},
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Icon(Icons.check,
                                                size: 25, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                ]),

                            Text("Révision à faire avant le ", style: TextStyle_regular),
                            Text("Cliquez ici pour prendre rendez-vous",
                                style: TextStyle_regular_green),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }

/*
  //Obtenir position GPS
  getUserLocation() async {
    final loc = await LocationService().getCity();
    if (loc != null) {
      setState(() {
        userPosition = loc;
      });
    }
  }
*/
}
