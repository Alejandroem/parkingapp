// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'api_energies/api_FrenchBornes_Response.dart';
import 'constants.dart';

class screen4_electricity extends StatefulWidget {
  const screen4_electricity({Key? key, this.androidDrawer, this.energy})
      : super(key: key);

  final Widget? androidDrawer;
  final String? energy;

  @override
  State<screen4_electricity> createState() => screen4_electricitystate();
}

class screen4_electricitystate extends State<screen4_electricity> {
  CancellationToken? cancellationToken;

  late List<Bornes> listBornes;

  int isLoaded = 0;
  double? _latitude;
  double? _longitude;
  String? msg;

  bool orderByPrice = true;
  bool ascendingOrder = true; // Track the sorting order
  bool DistascendingOrder = true; // Track the sorting order

  int nbPlaces =
      0; // number of places found using French database api and to show in the listview

// variables to change the color of the icons in the top bar
  int selectedIndex = 1;
  bool colorOne = true, colorTwo = false, colorThree = false;

//

  LocationData? locationData;

  @override
  void initState() {
    getListBornes();
    super.initState();
  }

  void cancel() {
    cancellationToken?.cancel();
  }

  Future<List?> getListBornes() async {
    /// step 0 : get user position

    try {
      Position position = await Geolocator.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print(e);
    }

    /// step 1 : create the url string
    // baseUrl = "https://www.mycarapp.fr:8443/mca/bornes?48.8739087,2.3174906,20";

    String baseUrl = "https://www.mycarapp.fr:8443/mca/bornes";
    String _lat = _latitude.toString();
    String _lon = _longitude.toString();
    int number = 20; // number of points adresses desired to be returned

    String _uri = "$baseUrl?$_lat,$_lon,$number";

    /// step 2 : get data from the server

    cancellationToken = CancellationToken();

    final uri = Uri.parse(_uri);

    final response = await get(uri);

    /// Step 1 : json.decode()
    List<dynamic> listeJson = json.decode(response.body);

    /// Step 2 : convert to a List
    listBornes = listeJson.map((item) => Bornes.fromJson(item)).toList();

    /// Print to test
    for (var e in listBornes) {
      print('Distance: ${e.distance}, Nom: ${e.nom_station}');
    }
    setState(() {
      isLoaded = 2;
    });
    return listBornes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: (isLoaded == 0)
                ? Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Nous interrogeons\n nos bases de données',
                              style: TextStyle_large,
                              textAlign: TextAlign.center),
                          UpDownLoader(
                            size: 12,
                            firstColor: Colors.teal,
                            secondColor: Colors.black,
                            //  duration: Duration(milliseconds: 600),
                          ),
                        ],
                      ),
                    ),
                  )
                : (isLoaded == 1)
                    ? Center(
                        child: Text(
                            'Malheureusement \nnous n\'avons trouvé aucune \nstation de recharge \n à proximité'),
                      )
                    : Column(
                        children: [
                          Container(
                            color: color_background2,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                /*
                                Text(

                                  '      Classement par proximité ',
                                  style: TextStyle_regular_white,
                                ),
                                */
                                IconButton(
                                  icon: Icon(
                                    Icons.price_change,
                                    color: selectedIndex == 1
                                        ? Colors.yellowAccent
                                        : Colors.white,
                                    size: 36,
                                  ),
                                  highlightColor: Colors.greenAccent,
                                  onPressed: () {
                                    selectedIndex = 1;
                                    // toggleSortOrder();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.maps_ugc_outlined,
                                    color: selectedIndex == 2
                                        ? Colors.yellowAccent
                                        : Colors.white,
                                    size: 36,
                                  ),
                                  highlightColor: Colors.greenAccent,
                                  onPressed: () {
                                    selectedIndex = 2;
                                    // toggleDIstSortOrder();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: listBornes.length,
                              //10, // apiResponse?.nhits,
                              itemBuilder: (context, index) => Card(
                                child: ListTile(
                                  minLeadingWidth: 0,
                                  leading: CircleAvatar(
                                    radius: 12.0,
                                    backgroundColor: color_background2,
                                    child: Text(
                                      ".",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    listBornes[index]
                                        .adresse_station
                                        .toString(),
                                    style: TextStyle_regular2,
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Distance : " +
                                            listBornes[index]
                                                .distance
                                                .toString(),
                                        style: TextStyle_regular2,
                                      ),
                                      Text(
                                        "Puissance nominale : " +
                                            listBornes[index]
                                                .puissance_nominale
                                                .toString(),
                                        style: TextStyle_regular2,
                                      ),
                                    ],
                                  ),
                                ),
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

  DistanceFormat(String _distance) {
    var formatDistance;
    var fDistance = NumberFormat("##,###", "fr_FR");
    (_distance == 'null')
        ? formatDistance = 'N.C.'
        : formatDistance =
            fDistance.format(double.tryParse(_distance.toString()));
    return formatDistance;
  }

  String PriceFormat(String _price) {
    if (_price == "--") return "";
    var formatPrice;
    var fPrice = NumberFormat("#.##", "fr_FR");
    (_price == 'null')
        ? formatPrice = 'N.C.'
        : formatPrice = fPrice.format(double.tryParse(_price.toString()));
    return formatPrice;
  }
/*
  void sortBySp98PrixAscending() {
    setState(() {
      listBornes.sort((a, b) =>
          (a.sp98_prix ?? '').compareTo(b.fields.sp98_prix ?? ''));
    });
  }

  void sortBySp98PrixDescending() {
    setState(() {
      listBornes.sort((a, b) =>
          (b.fields.sp98_prix ?? '').compareTo(a.fields.sp98_prix ?? ''));
    });
  }

  void sortByDistAscending() {
    setState(() {
      listBornes.sort((a, b) => (a.fields.dist ?? '').compareTo(b.fields.dist ?? ''));
    });
  }

  void sortByDistDescending() {
    setState(() {
      listBornes.sort((a, b) => (b.fields.dist ?? '').compareTo(a.fields.dist ?? ''));
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
  */
}
