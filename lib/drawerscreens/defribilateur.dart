// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api_controle_technique/api_FrenchControleTechnique_call.dart';
import '../api_defribilateur/api_defribilateur_call.dart';
import '../api_defribilateur/api_defribilateur_response.dart';
import '../model/geo_position.dart';
import '../services/data_services.dart';
import '../services/location_service.dart';

import '../utils.dart';
import '../constants.dart';
import '../widget/widgets.dart';
import '../text_FR.dart';
import '../utils.dart';
import '../widget/widgets.dart';
import '../text_FR.dart';

class defribilateur extends StatefulWidget {
  const defribilateur({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<defribilateur> createState() => defribilateurState();
}

class defribilateurState extends State<defribilateur> {

  static const _itemsLength = 10;

  bool _isLoading = false;
  bool orderByPrice = true;

  GeoPosition? positionToCall;
  ApiDefribilateur_response? apiResponse;

  @override
  void initState() {
    getGeoPosition();
    super.initState();
  }

  //Obtenir position GPS
  getGeoPosition() async {
    // find position of the user
    final loc = await LocationService().getCity();
    if (loc != null) {
      setState(() {
        positionToCall = loc;
      });
      // call French Controle Technique API
      getdefribilateurList();
    }
  }

  //CallApi to get Energies Prices
  getdefribilateurList() async {
    if (positionToCall == null) return;
    setState(() {
      _isLoading = true;
    }); //show loader
    print ('******************************REQUEST apiResponseCT********************************');
   // apiResponse = (await ApiDefribilateur().Debrifilateur(positionToCall!)) as ApiDefribilateur_response?;
    setState(() {
      print ('***********************************apiResponseCT********************************');
      print(apiResponse);
      _isLoading = false;
    }); //hide loader
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    if (_isLoading) {
      return Container(
        // margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(10),
          height: (size.height),
          width: size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Nous interrogeons",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
                Text("la base de données des Controles Technique",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
                Transform.scale(
                  scale: 2,
                  child: CircularProgressIndicator(
                    //value:0,
                    color: Colors.deepPurple,
                    semanticsLabel: 'en cours d interrogation',
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Centres de controle technique'),
        ),
        body: Column(
          children: [
            Container(
              color: color_background2,
              child: Row(
                children: [
                  Text(
                    '      Classement par prix ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.price_change,
                      color: Colors.white,
                    ),
                    highlightColor: Colors.greenAccent,
                    onPressed: () {
                      orderByPrice = true;
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.social_distance,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      orderByPrice = false;
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _itemsLength,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: color_background2,
                      child: Text(
                        "", // titles[index].substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                        'test',
                        style: TextStyle_small),
                    subtitle: Text(
                        "Visite : ",
                        style: TextStyle_verysmall),
                  ),
                  //trailing: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  PriceFormat(String _price) {
    var formatPrice;
    var fPrice = NumberFormat("#.##", "fr_FR");
    (_price == 'null')
        ? formatPrice = 'N.C.'
        : formatPrice = fPrice.format(double.tryParse(_price.toString()));
    return formatPrice;
  }

  DistanceFormat(String _distance) {
    var formatDistance;
    var fDistance = NumberFormat("##,###", "fr_FR");
    (_distance == 'null')
        ? formatDistance = 'N.C.'
        : formatDistance =
        fDistance.format(double.tryParse(_distance.toString()));
    return formatDistance;
  }

/*
  void _sortProducts(bool ascending) {
    setState(() {
      //_sortAscending = ascending;
      apiResponseCT?.records.sort((a, b) => ascending
          ? a['sp98_prix'].compareTo(b['sp98_prix'])
          : b['dist'].compareTo(a['dist']));
    });
  }
*/
}
