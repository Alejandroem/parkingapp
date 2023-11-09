// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../constants.dart';
import '../panne/panne_autre.dart';
import '../services/location_service.dart';
import '../model/dev_en_cours.dart';

class pannes extends StatefulWidget {
  const pannes({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<pannes> createState() => pannesState();
}

class pannesState extends State<pannes> {

  GeoPosition? positionToCall;

  List<String> cities = [];

  @override
  void initState() {
    getGeoPosition();
    super.initState();
  }



  var _position = "";

  //Obtenir position GPS
  getGeoPosition() async {
    // find position of the user
    final loc = await LocationService().getCity();

    if (loc != null) {
      setState(() {
         _position = loc.lat.toString()+","+ loc.lon.toString() ;
      }
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;


    String _batterie   = "depannage+batterie+voiture";
    String _essence    = "depannage+essence";
    String _crevaison  = "depannage+crevaison";
    String _depanneur  = "depanneur+voiture";
    String _remorquage = "remorquage+voiture";

    String  base_url   = "https://www.google.fr/maps/search/";

    String _url_batterie   = base_url + _batterie   + "/@" + _position + "z";
    String _url_essence    = base_url + _essence    + "/@" + _position + "z";
    String _url_crevaison  = base_url + _crevaison  + "/@" + _position + "z";
    String _url_depanneur  = base_url + _depanneur  + "/@" + _position + "z";
    String _url_remorquage = base_url + _remorquage + "/@" + _position + "z";


    return Scaffold(
      appBar: AppBar(
        title: const Text('Pannes'),
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
                                          Text("Dans quel cas êtes vous ?",
                                              style: TextStyle_regular),
                                        ]),
                                  ),

                                ],
                              )),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            height: size.height - 280,
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

                                        SizedBox(
                                            width:(size.width-75),
                                            height:90,
                                            child:
                                            ElevatedButton.icon(   // <-- ElevatedButton
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => DevEnCours()));
                                                },
                                              icon: Icon( Icons.check, size: 36.0 ),
                                              label: Text('Sur une autoroute', style: TextStyle_regular_white),
                                            ),
                                          ),


                                SizedBox(
                                  width:(size.width-75),
                                  height:90,
                                  child:
                                  ElevatedButton.icon(   // <-- ElevatedButton
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => DevEnCours()));
                                    },
                                    icon: Icon(Icons.check, size: 36.0 ),
                                    label: Text('Sur le périphérique', style: TextStyle_regular_white),
                                  ),
                                ),


                                SizedBox(
                                  width:(size.width-75),
                                  height:90,
                                  child:
                                  ElevatedButton.icon(   // <-- ElevatedButton
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => pannes_autres()));
                                    },
                                    icon: Icon(Icons.check, size: 36.0),
                                    label: Text('Ailleurs', style: TextStyle_regular_white),
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
