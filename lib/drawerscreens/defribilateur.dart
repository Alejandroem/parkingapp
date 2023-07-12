// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mycar/widget/loading_shimmer.dart';

import '../constants.dart';
import '../api_defribilateur/api_defribilateur_call.dart';
import '../api_defribilateur/api_defribilateur_response.dart';
import '../services/location_service.dart';



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
  List<dynamic> collectproxDef = [];
  List<dynamic> listProxDef = [];
  ApiDefribilateurCall? apiDefribilateurCall;
   ApiDefribilateur_response? response;

  @override
  void initState() {
     DefribilateursList();

    super.initState();
  }


  DefribilateursList() async {
     ApiDefribilateurCall apiDefribilateurCall =  await ApiDefribilateurCall();
     // print('Def print');
     //  print(apiDefribilateurCall.DefribilateursList());
     //
     collectproxDef  = await apiDefribilateurCall.DefribilateursList();

        setState(() {
          listProxDef = collectproxDef;
        });

        print('this is ListProx def ${listProxDef}');
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
                Text("la base de données des défribilateurs",
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
          title: const Text('Liste des défribilateurs à proximité'),
        ),
        body: Column(
          children: [
        listProxDef.isEmpty ? ShimmerListLoading() :   Expanded(
              child: ListView.builder(
                itemCount: _itemsLength,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: color_background2,
                      child: Text(
                        ".",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                        "*",
                        // apiDefribilateurCall?[index].nom,
                        style: TextStyle_small),
                    subtitle: Text(
                        // response!.latCoor1.toString()
                        //     + " " + response!.gid.toString()
                        //     + " - " + response!.gid.toString()
                        //     + " " + response!.gid.toString(),
                        listProxDef[index]['etat_valid'].toString()


                        ,style: TextStyle_verysmall
                    ),
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


class TokenAPI {
  String? token;

  TokenAPI(
      {this.token});

  TokenAPI.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}


