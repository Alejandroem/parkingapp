// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants.dart';

class mapshow extends StatefulWidget {

  final double? lat;
  final double? lon;
  mapshow({this.lat,this.lon});

  @override
  State<mapshow> createState() => mapshowState();
}

class mapshowState extends State<mapshow> {

  double? _lat;
  double? _lon;


  @override
  void initState(){
    super.initState();
    setState(() {
      _lat = widget.lat;
      _lon = widget.lon;
    });
  }


  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;

    CameraPosition initialCameraPosition = CameraPosition(
      //  bearing: ,
        target: LatLng( _lat!, _lon!),
        // tilt: ,
        zoom: 18
    );

    final Marker _kGooglePlexMarker = Marker(
      markerId: MarkerId('_kGooglePlex'),
      icon:  BitmapDescriptor.defaultMarker,
      position: LatLng(_lat!, _lon!),
    );

    return Scaffold(
      appBar: AppBar(
        title:  Text(
            'Votre dernier stationnement'),
            backgroundColor: color_background2,
      ),
      body: Container(
          height: size.height,
          width: size.width,
         // color: Colors.white,
          child:
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: {_kGooglePlexMarker},
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            myLocationEnabled: true,
            circles: Set.from([
              Circle( circleId:
              CircleId('currentCircle'),
                    center: LatLng(_lat!, _lon!),
                    radius: 40,
                    fillColor: Colors.blue.shade100.withOpacity(0.5),
                    strokeColor:  Colors.blue.shade100.withOpacity(0.1),
                   ),
                 ],
            ),
            onMapCreated: (GoogleMapController controller){
              googleMapController = controller;
            },
          ),

      )
    );
  }



}
