// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../constants.dart';
import '../text_FR.dart';
import 'package:url_launcher/url_launcher.dart';


class accident extends StatefulWidget {
  const accident({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<accident> createState() => accidentState();
}

class accidentState extends State<accident> {
  static const _itemsLength = 6;

  late final List<Color> colors;
  late final List<String> titles;
  late final List<String> contents;

  @override
  void initState() {
    colors = [
    Colors.blue,
    Colors.blue,
    Colors.green,
    Colors.blue,
    Colors.blue,
    Colors.red
    ];
    titles = [
      title_cl_00,
      title_cl_01,
      title_cl_02,
      title_cl_03,
      title_cl_04,
      title_cl_05
    ];
    contents = [
      texte_cl_00,
      texte_cl_01,
      texte_cl_02,
      texte_cl_03,
      texte_cl_04,
      texte_cl_05
    ];
    super.initState();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accident'),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Constat Amiable",
                                            style: TextStyle_large),
                                      ]),
                                ),
                                Container(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                             StoreLaunch();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: color_background2,
                                              elevation: 10,
                                              shadowColor: Colors.white,
                                            ),
                                            child:  Text("Remplir un constat en ligne",
                                                style: TextStyle_smallwhite),
                                        ),
                                      ]),
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          height: (size.height / 2) - 10,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: color_background,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Contactez directement",
                                          style: TextStyle_large),
                                    ]),
                              ),
                              Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                              ),
                              Container(
                                child:
                                     Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width:(size.width/2-50),
                                                height:60,
                                                child:
                                                  ElevatedButton.icon(   // <-- ElevatedButton
                                                  onPressed: () {},
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors.redAccent,
                                                        textStyle: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold)),
                                                  icon: Icon(
                                                    Icons.call,
                                                    size: 36.0,
                                                  ),
                                                  label: Text('Police'),
                                                ),
                                              ),

                                              Spacer(),

                                              SizedBox(
                                                width:(size.width/2-50),
                                                height:60,
                                                child:
                                                ElevatedButton.icon(   // <-- ElevatedButton
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.redAccent,
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold)),
                                                  icon: Icon(
                                                    Icons.call,
                                                    size: 36.0,
                                                  ),
                                                  label: Text('Pompier'),
                                                ),
                                              ),

                                              ],

                                          ),

                                        ],
                                      ),




                                ),

                              Container(
                                child:
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:(size.width/2-50),
                                          height:60,
                                          child:
                                          ElevatedButton.icon(   // <-- ElevatedButton
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.lightBlue,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            icon: Icon(
                                              Icons.call,
                                              size: 36.0,
                                            ),
                                            label: Text('SAMU'),
                                          ),
                                        ),

                                        Spacer(),

                                        SizedBox(
                                          width:(size.width/2-50),
                                          height:60,
                                          child:
                                          ElevatedButton.icon(   // <-- ElevatedButton
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.lightBlue,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            icon: Icon(
                                              Icons.call,
                                              size: 36.0,
                                            ),
                                            label: Text('Médecin'),
                                          ),
                                        ),

                                      ],

                                    ),

                                  ],
                                ),




                              ),

                              Container(
                                child:
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:(size.width/2-50),
                                          height:60,
                                          child:
                                          ElevatedButton.icon(   // <-- ElevatedButton
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.orangeAccent,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            icon: Icon(
                                              Icons.call,
                                              size: 36.0,
                                            ),
                                            label: Text('Assureur'),
                                          ),
                                        ),

                                        Spacer(),

                                        SizedBox(
                                          width:(size.width/2-50),
                                          height:60,
                                          child:
                                          ElevatedButton.icon(   // <-- ElevatedButton
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.orangeAccent,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            icon: Icon(
                                              Icons.call,
                                              size: 36.0,
                                            ),
                                            label: Text('Garage'),
                                          ),
                                        ),

                                      ],

                                    ),

                                  ],
                                ),




                              ),

                              Container(
                                child:
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:(size.width/2-50),
                                          height:60,
                                          child:
                                          ElevatedButton.icon(   // <-- ElevatedButton
                                            onPressed: () {_makePhoneCall('+33619568376');},
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.greenAccent,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            icon: Icon(
                                              Icons.call,
                                              size: 36.0,
                                            ),
                                            label: Text('Ami 1'),
                                          ),
                                        ),

                                        Spacer(),

                                        SizedBox(
                                          width:(size.width/2-50),
                                          height:60,
                                          child:
                                          ElevatedButton.icon(   // <-- ElevatedButton
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.greenAccent,
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold)),
                                            icon: Icon(
                                              Icons.call,
                                              size: 36.0,
                                            ),
                                            label: Text('Ami 2'),
                                          ),
                                        ),

                                      ],

                                    ),

                                  ],
                                ),

                              ),


                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            height: (size.height / 2) - 300,
                            width: size.width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            color: color_background,
                            borderRadius: BorderRadius.circular(border_radius),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Photos de l'accident",
                                            style: TextStyle_large),
                                      ]),
                                ),
                                Container(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {

                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: color_background2,
                                              elevation: 10,
                                              shadowColor: Colors.white,
                                            ),
                                            child: const Text("Prendre des photos certifiées par huissier")),
                                      ]),
                                ),


                              ],
                            )),
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

  void StoreLaunch(){
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? 'YOUR_ANDROID_PACKAGE_ID' : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
    return;
  }
  
}
