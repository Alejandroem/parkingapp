import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

import '../constants.dart';
import '../domain/models/lat_lng.dart';

class ParkingMap extends StatelessWidget {
  final LatitudeLongitude initialLocation;
  const ParkingMap(this.initialLocation, {super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        minZoom: 6,
        maxZoom: 18,
        zoom: 18,
        center: LatLng(
          initialLocation.latitude,
          initialLocation.longitude,
        ),
        rotation: 0,
        interactiveFlags: InteractiveFlag.drag |
            InteractiveFlag.flingAnimation |
            InteractiveFlag.pinchMove |
            InteractiveFlag.pinchZoom |
            InteractiveFlag.doubleTapZoom,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/alejandroem/clkd2qmll005r01qk8xjbht2g/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxlamFuZHJvZW0iLCJhIjoiY2xrYTFydDF5MDJmbDNzbDVuZnZlazRhaSJ9.hiZCPRVL85J0nXGC7wGvug",
          additionalOptions: const {
            'mapStyleId': AppConstants.mapBoxStyleId,
            'accessToken': AppConstants.mapBoxAccessToken,
          },
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                initialLocation.latitude,
                initialLocation.longitude,
              ),
              builder: (ctx) => const Icon(
                Icons.local_parking,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
