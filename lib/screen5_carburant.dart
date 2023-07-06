// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../api_carburants/api_FrenchDataEnergies_response_old.dart';
import '../api_carburants/api_FrenchDataEnergies_call.dart';
import '../services/location_service.dart';
import '../constants.dart';

class screen5_carburant extends StatefulWidget {
  const screen5_carburant({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<screen5_carburant> createState() => screen5_carburantState();
}

class screen5_carburantState extends State<screen5_carburant> {
  static const _itemsLength = 10;

  bool _isLoading = false;
  bool orderByPrice = true;

  int _nbPlaces = 0;

  GeoPosition? positionToCall;

  List<String> cities = [];
  APIResponse? apiResponse;

  @override
  void initState() {
    getGeoPosition();
    super.initState();
  }

  // Get position GPS
  getGeoPosition() async {
    // find position of the user
    final loc = await LocationService().getCity();
    if (loc != null) {
      setState(() {
        positionToCall = loc;
      });
      // call French Data Energies API
      getEnergiesPrices();
    }
  }

  //CallApi to get Energies Prices
  Future<Object?> getEnergiesPrices() async {
    apiResponse = await ApiFranceCarburants()
        .FrenchDataEnergiesApi(positionToCall!); //wait for update
    if (apiResponse!.nhits! > 0) {
      _nbPlaces = apiResponse?.records as int;
      return _nbPlaces;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEnergiesPrices(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('=============== 1 ==============');
          return Scaffold(
            appBar: AppBar(
              title: const Text('Carburants'),
            ),
            body: Center(
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text("Patientez",
                      style: TextStyle_large,
                    ),

                    Text("Nous interrogeons la base de donnée :",
                      style: TextStyle_regular,
                    ),

                    Text("nationales des prix des carburants",
                      style: TextStyle_regular,
                    ),

                    Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: 200,
                        width: 200,
                        child: CircularProgressIndicator()
                    ),

                    Text(". . .",
                      style: TextStyle_regular,
                    ),
                  ],
                )
            ),
          );
        }
          return Scaffold(
            body: Column(
              children: [
                Container(
                  color: color_background2,
                  child: Row(
                    children: [
                      Text(
                        '      Classement par proximité ',
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
                          //    apiResponse!.records.sort((a, b) => a.fields.dist?.compareTo(b.fields.dist?));
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
                            (apiResponse?.records[index].fields.adresse != null)
                                ? apiResponse!.records[index].fields.adresse
                                        .toString() +
                                    " (" +
                                    DistanceFormat(apiResponse!
                                        .records[index].fields.dist
                                        .toString()) +
                                    ' m)'
                                : "",
                            style: TextStyle_small),
                        subtitle: Text(
                            "SP98 : " +
                                PriceFormat(apiResponse!
                                    .records[index].fields.sp98_prix
                                    .toString())
                                // + " - e85 : "    + PriceFormat(apiResponse!.records[index].fields.e85_prix.toString())
                                +
                                " - e10 : " +
                                PriceFormat(apiResponse!
                                    .records[index].fields.e10_prix
                                    .toString()) +
                                " - Diesel : " +
                                PriceFormat(apiResponse!
                                    .records[index].fields.gazole_prix
                                    .toString()),
                            style: TextStyle_regular),
                      ),
                      //trailing: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
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

  ///*  the function to sort ....  but DO NOT WORK ....
  ///
  ///
  ///
/*
  void _sortProducts(bool ascending) {
    setState(() {
      //_sortAscending = ascending;
      apiResponse?.records.sort((a, b) => ascending
          ? a.['sp98_prix'].compareTo(b['sp98_prix'])
          : b['dist'].compareTo(a['dist']));
    });
  }

   */
}
