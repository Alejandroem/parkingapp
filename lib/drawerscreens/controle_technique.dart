// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api_controle_technique/api_FrenchControleTechnique_call.dart';
import '../api_controle_technique/api_FrenchControleTechnique_response.dart';
import '../services/location_service.dart';

import '../constants.dart';

class controletechnique extends StatefulWidget {
  const controletechnique({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<controletechnique> createState() => controletechniqueState();
}

class controletechniqueState extends State<controletechnique> {

  static const _itemsLength = 10;

  int isLoaded = 0;

  bool orderByPrice = true;
  bool ascendingOrder = true; // Track the sorting order
  bool DistascendingOrder = true; // Track the sorting order

  GeoPosition? positionToCall;
  APIResponse? apiResponseCT;

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
      getControleTechniquePrices();
    }
  }

  //CallApi to get Energies Prices
  getControleTechniquePrices() async {
    if (positionToCall == null) return;
    setState(() {
      isLoaded = 0;
    }); //show loader
    print(
        '******************************REQUEST apiResponseCT********************************');
    apiResponseCT = await ApiControleTechnique()
        .ControleTechniqueApi(positionToCall!); //wait for update
    setState(() {
      print(
          '***********************************apiResponseCT********************************');
      print(apiResponseCT);
      isLoaded = 1;
    }); //hide loader
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    var platform = Theme
        .of(context)
        .platform;
    return Scaffold(
      appBar: AppBar(
        title: Text("Défribillateurs à proximité"),
      ),
      body: Column(
          children: [
          Expanded(
          child: (isLoaded == 0)
          ? Container(
        // margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(10),
          height: (size.height),
          width: size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Nous interrogeons\n la base de données des Controles Technique",
                    style: TextStyle_large,
                    textAlign: TextAlign.center,
                    ),
                UpDownLoader(
                  size: 12,
                  firstColor: Colors.teal,
                  secondColor: Colors.black,
                  //  duration: Duration(milliseconds: 600),
                  ),
              ],
            ),
          )
      )

          : Column(
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
                    itemBuilder: (context, index) =>
                        Card(
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
                                (apiResponseCT?.records[index].fields
                                    .cct_denomination != null)
                                    ? apiResponseCT!.records[index].fields.cct_denomination.toString() +
                                    " (" +
                                    DistanceFormat(apiResponseCT!.records[index].fields.dist.toString()) +
                                    ' m)'
                                    : "",
                                style: TextStyle_small),
                            subtitle: Text(
                                "Visite : " +
                                    PriceFormat(apiResponseCT!.records[index].fields.prix_visite.toString()) +
                                    " contre visite (min/max) : " +
                                    PriceFormat(apiResponseCT!.records[index].fields.prix_contre_visite_min.toString()) +
                                    " / " +
                                    PriceFormat(apiResponseCT!.records[index].fields.prix_contre_visite_max.toString()),
                                style: TextStyle_verysmall),
                          ),
                          //trailing: const Icon(Icons.arrow_forward),
                        ),
                  ),
                ),
              ],
            ),
          ),
          ],
          ),
    );
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

  void sortByDistAscending() {
    setState(() {
      apiResponseCT?.records.sort((a, b) => (a.fields.dist ?? '').compareTo(b.fields.dist ?? ''));
    });
  }

  void sortByDistDescending() {
    setState(() {
      apiResponseCT?.records.sort((a, b) => (b.fields.dist ?? '').compareTo(a.fields.dist ?? ''));
    });
  }


/*
  void sortBySp98PrixAscending() {
    setState(() {
      apiResponseCT?.records.sort((a, b) => (a.fields.prix_visite ?? '').compareTo(b.fields.prix_visite ?? ''));
    });
  }

  void sortBySp98PrixDescending() {
    setState(() {
      apiResponseCT?.records.sort((a, b) => (b.fields.prix_visite ?? '').compareTo(a.fields.prix_visite ?? ''));
    });
  }


  void toggleSortOrder() {
    setState(() {
      ascendingOrder = !ascendingOrder;
      if (ascendingOrder) {
        sortBySp98PrixAscending();
      } else {
        sortBySp98PrixDescending();
      }
    });
  }
  */
  void toggleDIstSortOrder() {
    setState(() {
      DistascendingOrder = !DistascendingOrder;
      if (ascendingOrder) {
        sortByDistAscending();
      } else {
        sortByDistDescending();
      }
    });
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
*/}
