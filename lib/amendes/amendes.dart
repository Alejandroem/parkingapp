// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../constants.dart';
import 'amendes_scanner.dart';

class amendes extends StatefulWidget {
  const amendes({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<amendes> createState() => amendesState();
}

class amendesState extends State<amendes> {


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
        title: const Text('amendes'),
        backgroundColor: color_background2,
      ),
      body: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Center(
              child: Card(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column (
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              height: (size.height / 3) - 150,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: color_background,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Avez vous reçu :",
                                              style: TextStyle_regular),
                                        ]),
                                  ),

                                ],
                              )),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            height: size.height - 500,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: color_background,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                SizedBox(
                                  width:(size.width-75),
                                  height:90,
                                  child:
                                  ElevatedButton.icon(   // <-- ElevatedButton
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => AmendesScanner()));
                                    },
                                    icon: Icon( Icons.check, size: 36.0 ),
                                    label: Text('un FPS ?', style: TextStyle_regular_white),
                                  ),
                                ),


                                SizedBox(
                                  width:(size.width-75),
                                  height:90,
                                  child:
                                  ElevatedButton.icon(   // <-- ElevatedButton
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => AmendesScanner()));
                                    },
                                    icon: Icon(Icons.check, size: 36.0 ),
                                    label: Text('une Amende ?', style: TextStyle_regular_white),
                                  ),
                                ),



                              ],
                            ),
                          ),

                        ],
                      ),
                    )

                ),
                elevation: 7.5,
                //color: Colors.teal,
                margin: EdgeInsets.all(10),
              ))),
    );
  }

}
