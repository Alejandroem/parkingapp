// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../constants.dart';
import '../services/location_service.dart';

class defribillateur extends StatefulWidget {
  const defribillateur({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<defribillateur> createState() => defribillateurstate();
}

class defribillateurstate extends State<defribillateur> {
  CancellationToken? cancellationToken;

  late List<Defribillateurs> listDefribilateurs;

  int isLoaded = 0;

  String? msg;

  LocationData? locationData;

  @override
  void initState() {
    DefribillateursRequest();
    super.initState();
  }

  void cancel() {
    cancellationToken?.cancel();
  }

  Future<List?> DefribillateursRequest() async {
    /// step 0 : get user position

    final loc = await LocationService().getPosition();
    if (loc != null) {
      setState(() {
        locationData = loc;
      });
    }

    /// step 1 : get data from the server

    print(
        '-------------------------------/ Defribillateurs Request 1--------------------------------------');

    // https://www.mycarapp.fr:8443/mca/defribillateurs?48.8739087,2.3174906,20

    String _urlPrefix = "https://www.mycarapp.fr:8443"; // ""https://pjb.acme-sas.com"; // "http://82.66.244.99:500";
    String _urlPath = "/mca/defribillateurs";
    String? _lattitude = locationData?.latitude.toString();
    String? _longitude = locationData?.longitude.toString();
    String _nb ="20";

    String _url = "$_urlPrefix$_urlPath?$_lattitude,$_longitude,$_nb";

    final Uri url = Uri.parse(_url);

    print('-----_url : $_url');

    setState(() {
      msg = 'begin request';
    });

    cancellationToken = CancellationToken();

    try {
      await HttpClientHelper.get(
        url,
        cancelToken: cancellationToken,
        timeRetry: const Duration(milliseconds: 100),
        retries: 3,
        timeLimit: const Duration(seconds: 200),
      ).then((Response? response) {
        // setState(() {
        print('*****************************************');
        print('response if ok from the server');
        print(response!.body);
        print('*****************************************');

        /// Step 1 : json.decode()
        List<dynamic> listeJson = json.decode(response.body);

        /// Step 2 : convert to a List
        listDefribilateurs = listeJson.map((item) => Defribillateurs.fromJson(item)).toList();

        /// Print to test
        for (var e in listDefribilateurs) {
          print('Distance: ${e.distance}, Nom: ${e.c_nom}');
        }

        setState(() {
          isLoaded = 2;
        });

       print ("isLoaded = $isLoaded");

       return listDefribilateurs;
          });
    } on TimeoutException catch (_) {
      setState(() {
        msg = 'TimeoutException';
        setState(() {
          isLoaded = 1;
        });
        return null;
      });
    } on OperationCanceledError catch (_) {
      setState(() {
        msg = 'cancel';
        setState(() {
          isLoaded = 1;
        });
        return null;
      });
    } catch (e) {
      setState(() {
        msg = '$e';
        setState(() {
          isLoaded = 1;
        });
        return null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Défribillateurs à proximité"),
      ),
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
                            Text('Nous interrogeons la base \ndes défribillateurs à proximité de vous',
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
                          child: Text('Malheureusement \nnous n\'avons trouvé aucun défribillateurs \n à proximité'),
                      )
                    : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: listDefribilateurs.length,
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
                                      listDefribilateurs[index].c_nom.toString(),
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
                                              listDefribilateurs[index]
                                                  .distance
                                                  .toString(),
                                          style: TextStyle_regular2,
                                        ),
                                        Text(
                                          listDefribilateurs[index]
                                              .c_adr_num
                                              .toString() +
                                              " " +
                                              listDefribilateurs[index]
                                                  .c_adr_voie
                                                  .toString() +
                                              " - " +
                                              listDefribilateurs[index]
                                                  .c_com_cp
                                                  .toString() +
                                              " " +
                                              listDefribilateurs[index]
                                                  .c_com_nom
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
}

class Defribillateurs {
  final String? c_acc;
  final String? c_acc_etg;
  final String? c_adr_num;
  final String? c_adr_voie;
  final String? c_com_cp;
  final String c_com_nom;

  // final List?<horaires> c_disp_h;
  // final List?<jours> c_disp_j;
  final String? c_nom;
  final String? distance;

  Defribillateurs({
    required this.c_acc,
    required this.c_acc_etg,
    required this.c_adr_num,
    required this.c_adr_voie,
    required this.c_com_cp,
    required this.c_com_nom,
    // required this.c_disp_h,
    // required this.c_disp_j,
    required this.c_nom,
    required this.distance,
  });

  factory Defribillateurs.fromJson(Map<String, dynamic> json) {
    return Defribillateurs(
      c_acc: json['c_acc'],
      c_acc_etg: json['c_acc_etg'],
      c_adr_num: json['c_adr_num'],
      c_adr_voie: json['c_adr_voie'],
      c_com_cp: json['c_com_cp'],
      c_com_nom: json['c_com_nom'],
      // c_disp_h: json['c_disp_h']: List<String>.from(json['c_disp_h']),
      // c_disp_j: json['c_disp_j']: List<String>.from(json['c_disp_j']),
      c_nom: json['c_nom'],
      distance: json['distance'],
    );
  }
}

class horaires {}

class jours {}

/* example of one record from the response Json
  {"c_acc":"Int\u00e9rieur",
  "c_acc_etg":"BUREAUX ",
  "c_adr_num":"4",
  "c_adr_voie":"Rue de Penthi\u00e8vre",
  "c_com_cp":"75008",
  "c_com_nom":"Paris",
  "c_disp_h":["heures ouvrables"],
  "c_disp_j":["lundi","mardi","mercredi","jeudi","vendredi"],
  "c_nom":"DAE PENTHIEVRE",
  "distance":"78 m"}
   */
