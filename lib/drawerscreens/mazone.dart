// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../constants.dart';
import '../text_FR.dart';
import '../utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class maZoneResidentielle extends StatefulWidget {
  const maZoneResidentielle({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<maZoneResidentielle> createState() => maZoneResidentielleState();
}

class maZoneResidentielleState extends State<maZoneResidentielle> {
  static const _itemsLength = 6;

  late final List<Color> colors;
  late final List<String> titles;
  late final List<String> contents;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Zone résidentielle'),
        backgroundColor: color_background2,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child:   Column (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text('Ma Zone résidentielle'),

  
                  ],
                )
            ),

        );

  
  }

}
