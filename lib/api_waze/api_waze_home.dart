// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/location_service.dart';
import 'api_waze_call.dart';
import 'api_waze_response.dart';

class Waze extends StatefulWidget {
  const Waze({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<Waze> createState() => WazeState();
}

class WazeState extends State<Waze> {

  static const _itemsLength = 10;

  bool _isLoading = false;
  bool orderByPrice = true;

  GeoPosition? positionToCall;
  ApiWaze_response? apiWaze_response;

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
      // call Api Waze
      getWazeAlerts();
    }
  }

  //CallApi to get Energies Prices
  getWazeAlerts() async {
    if (positionToCall == null) return;
    setState(() {
      _isLoading = true;
    }); //ok to show loader
    print ('******************************REQUEST WazeCall***************************************');
    apiWaze_response = (await WazeCall().WazeResponseApi(positionToCall!)) as ApiWaze_response?; //wait for update
    setState(() {
      print ('***********************************apiWaze_response********************************');
      print(apiWaze_response);
      print ('***********************************apiWaze_response********************************');
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
        //  height: (size.height),
        //  width: size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Nous interrogeons",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
                Text("la base de données des alertes Waze",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
                Transform.scale(
                  scale: 2,
                  child: CircularProgressIndicator(
                    //value:0,
                    color: Colors.teal,
                    semanticsLabel: 'en cours d interrogation',
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Alertes Waze'),
        ),
        body: Column(
          children: [
          Text(
            (apiWaze_response!.data!.alerts![1].subtype != null)
            ? apiWaze_response!.data!.alerts![1].subtype.toString()
             : "",
            )

            /*
                 ListView.builder(
                itemCount: _itemsLength,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: color_background2,
                      child: Text(
                        '1',
                        //apiWaze_response!.data!.alerts![index].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                        '2', //apiWaze_response!.data!.alerts![index].type.toString(),
                        style: TextStyle_regular),
                    subtitle: Text(
                        '3', //apiWaze_response!.data!.alerts![index].subtype.toString(),
                        style: TextStyle_small),
                    trailing: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
            */
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


}
