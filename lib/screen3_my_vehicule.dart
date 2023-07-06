// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants.dart';


class screen3_my_vehicule extends StatefulWidget {
  const screen3_my_vehicule({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<screen3_my_vehicule> createState() => screen3_my_vehiculeState();
}

class screen3_my_vehiculeState extends State<screen3_my_vehicule> {
  // const screen3_my_vehicule({super.key});



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
   // print("size: $size");
   // print("platform: $platform");
    return Scaffold(
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Center(
              child: Card(
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
                    height: (size.height / 2) - 50,
                    width: size.width,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          Text("Votre batterie :", style: TextStyle_large),
                          const SizedBox(height: 10.0),
                          CircularPercentIndicator(
                            radius: 115.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent: 0.7,
                            center: new Text(
                              "70.0%",
                              style: TextStyle_verylarge,
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.purple,
                          ),
                          const SizedBox(height: 20.0),
                          Text("Autonomie : " + " 287" + "Km",
                              style: TextStyle_regular),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    height: (size.height / 3) - 50,
                    width: size.width,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          Text("Check List", style: TextStyle_regular),
                          const SizedBox(height: 10.0),
                          Text("Batterie : débranchée",
                              style: TextStyle_regular),
                          const SizedBox(height: 10.0),
                          Text("Kilométrage : 8.352 km",
                              style: TextStyle_regular),
                          const SizedBox(height: 10.0),
                          Text("Prochaine révision : juillet 2023",
                              style: TextStyle_regular),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              print("ok");
                            },
                            style: ElevatedButton.styleFrom(
                              primary: color_background2,
                              elevation: 10,
                              shadowColor: Colors.white,
                            ),
                            child: Text("Mettre en marche la Clim",
                                style: TextStyle_button),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            elevation: 7.5,
            //color: Colors.teal,
            margin: EdgeInsets.all(10),
          ))),
    );
  }
}
