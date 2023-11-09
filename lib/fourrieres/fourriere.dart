// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



import '../constants.dart';
import 'fourriere_nice.dart';
import 'fourriere_notconnected.dart';
import 'fourriere_paris.dart';
import 'fourrieres_other.dart';


class fourriere extends StatefulWidget {
  const fourriere({super.key, this.androidDrawer, required this.immatriculation});

  final Widget? androidDrawer;
  final String immatriculation;

  @override
  State<fourriere> createState() => fourriereState();
}

class fourriereState extends State<fourriere> {

  late String immat;



  static const List<String> list = <String>[' ', 'Aix en Provence','Amiens','Angers','Annecy','Avignon','Besançon','Biarritz','Bonneuil-sur-Marne','Bordeaux','Brest','Caen','Chambéry','Clermont-Ferrand','Dijon','Douai','Dunkerque','Grenoble','La Courneuve','La Rochelle','Le Havre','Le Mans','Limoges','Lorient','Metz','Montpellier','Mulhouse','Nancy','Nantes','Nîmes','Pantin','Pau','Perpignan','Reims','Rennes','Roubaix','Rouen','Nantes','Saint-Etienne','Orleans','Saint-Nazaire','Strasbourg','Toulon','Toulouse','Tours','Troyes','Valenciennes'];

  String dropdownValue = list.first;

  final _immat = TextEditingController();

  @override
  void initState() {
    immat = widget.immatriculation;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;


    TextFormField _immatriculation = TextFormField(
      controller: _immat,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.immatriculation,
        labelStyle : TextStyle_large_grey,
        // icon: Icon(Icons.check_box_outline_blank),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
       ),
      style:
      TextStyle(fontSize: 30.0, color: Colors.teal),
      onChanged: (value) {
      setState(() {
        immat = value.toUpperCase();
      });
    },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fourrières'),
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
                              height: size.height / 5,
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
                                          Text("Votre plaque d'immatriculation",
                                              style: TextStyle_regular),
                                           Divider(),
                                           _immatriculation,

                                        ]),
                                  ),

                                ],
                              ),
                          ),

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

                                Text("Villes recherche automatique",
                                    style: TextStyle_regular,
                                    textAlign: TextAlign.center),

                                Container(
                                  height: 38,
                                  width: size.width-125,
                                  decoration: BoxDecoration(
                                      color: color_background,
                                      border: Border.all(
                                        color: color_background2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: TextButton(
                                    child: Text("Paris",
                                        style: TextStyle_regular_bold),
                                    onPressed: () {
                                      Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => fourriere_paris(url:"https://teleservices.paris.fr/fourrieres/",immatriculation: immat)));
                                    },
                                  ),
                                ),

                                Container(
                                  height: 38,
                                  width: size.width-125,
                                  decoration: BoxDecoration(
                                      color: color_background,
                                      border: Border.all(
                                        color: color_background2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: TextButton(
                                    child: Text("Nice",
                                        style: TextStyle_regular_bold),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => fourriere_nice(url:"https://fourriere.nice.fr/#mon-vehicule",immatriculation: immat)));
                                    },// <-- ElevatedButton
                                  ),
                                ),

                                Container(
                                  height: 38,
                                  width: size.width-125,
                                  decoration: BoxDecoration(
                                      color: color_background,
                                      border: Border.all(
                                        color: color_background2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: TextButton(
                                    child: Text("Lille, Lyon, Marseille",
                                        style: TextStyle_regular_bold),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => fourrieres(immatriculation: immat)));
                                    },// edButton
                                  ),
                                ),




                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            height: size.height / 5,
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
                                Text("Autres villes (non connectées)",
                                    style: TextStyle_regular_bold),

                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.teal),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.teal,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => fourriere_notconnectd(ville: dropdownValue)));

                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle_regular_bold),
                                    );
                                  }).toList(),
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
