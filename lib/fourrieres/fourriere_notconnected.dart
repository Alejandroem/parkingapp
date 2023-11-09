// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



import '../constants.dart';


class fourriere_notconnectd extends StatefulWidget {
  const fourriere_notconnectd({super.key, this.androidDrawer, required this.ville});

  final Widget? androidDrawer;
  final String ville;

  @override
  State<fourriere_notconnectd> createState() => fourriere_notconnectdState();
}

class fourriere_notconnectdState extends State<fourriere_notconnectd> {

  late String _ville;

  static const List<String> list = <String>[' ', 'Aix en Provence','Amiens','Angers','Annecy','Avignon','Besançon','Biarritz','Bonneuil-sur-Marne','Bordeaux','Brest','Caen','Chambéry','Clermont-Ferrand','Dijon','Douai','Dunkerque','Grenoble','La Courneuve','La Rochelle','Le Havre','Le Mans','Limoges','Lorient','Metz','Montpellier','Mulhouse','Nancy','Nantes','Nîmes','Pantin','Pau','Perpignan','Reims','Rennes','Roubaix','Rouen','Nantes','Saint-Etienne','Orleans','Saint-Nazaire','Strasbourg','Toulon','Toulouse','Tours','Troyes','Valenciennes'];


  @override
  void initState() {
    _ville = widget.ville ?? "";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;



    return Scaffold(
      appBar: AppBar(
        title: Text('Fourrière de $_ville'),
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
                            height: size.height /3,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Text("Voici les coordonnées de la Fourrière de $_ville",
                                    style: TextStyle_regular,
                                    textAlign: TextAlign.center),




                                SizedBox(
                                  width:(size.width/2-50),
                                  height:60,
                                  child:
                                  ElevatedButton.icon(   // <-- ElevatedButton
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    icon: Icon(
                                      Icons.call,
                                      size: 36.0,
                                    ),
                                    label: Text('Appeler'),
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
