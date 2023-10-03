import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:parking/application/cubits/location_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../constants.dart';
import '../domain/models/user_locations.dart';

class NavigationMap extends StatelessWidget {
  const NavigationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, UserLocation>(
      builder: (context, state) {
        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                minZoom: 6,
                maxZoom: 18,
                zoom: 18,
                center: LatLng(
                  state.currentLocation?.latitude ?? 0,
                  state.currentLocation?.longitude ?? 0,
                ),
                rotation: 0,
                interactiveFlags: InteractiveFlag.drag |
                    InteractiveFlag.flingAnimation |
                    InteractiveFlag.pinchMove |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom,
                onTap: (tapPosition, point) {
                  context.read<LocationCubit>().updateLastTappedLocation(
                        point.latitude,
                        point.longitude,
                      );
                },
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
                if (state.polylines != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.polylines!.map((e) {
                          return LatLng(e.latitude, e.longitude);
                        }).toList(),
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        state.currentLocation?.latitude ?? 0,
                        state.currentLocation?.longitude ?? 0,
                      ),
                      builder: (ctx) => const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    if (state.lastTappedLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          state.lastTappedLocation!.latitude,
                          state.lastTappedLocation!.longitude,
                        ),
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (state.wayPoints != null)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () async {
                      MapBoxNavigation.instance.setDefaultOptions(
                        MapBoxOptions(
                          initialLatitude: state.currentLocation!.latitude,
                          initialLongitude: state.currentLocation!.latitude,
                          zoom: 18.0,
                          tilt: 0.0,
                          bearing: 0.0,
                          enableRefresh: false,
                          alternatives: true,
                          voiceInstructionsEnabled: true,
                          bannerInstructionsEnabled: true,
                          allowsUTurnAtWayPoints: true,
                          mode: MapBoxNavigationMode.drivingWithTraffic,
                          /* mapStyleUrlDay:
                              "https://api.mapbox.com/styles/v1/alejandroem/clkd2qmll005r01qk8xjbht2g/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxlamFuZHJvZW0iLCJhIjoiY2xrYTFydDF5MDJmbDNzbDVuZnZlazRhaSJ9.hiZCPRVL85J0nXGC7wGvug",
                          mapStyleUrlNight:
                              "https://api.mapbox.com/styles/v1/alejandroem/clkd2qmll005r01qk8xjbht2g/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxlamFuZHJvZW0iLCJhIjoiY2xrYTFydDF5MDJmbDNzbDVuZnZlazRhaSJ9.hiZCPRVL85J0nXGC7wGvug", */
                          units: VoiceUnits.imperial,
                          simulateRoute: true,
                          language: "en",
                        ),
                      );
                      MapBoxNavigation.instance
                          .registerRouteEventListener(_onRouteEvent);

                      await MapBoxNavigation.instance.startNavigation(
                        wayPoints: state.wayPoints!,
                      );
                    },
                    child: const Icon(Icons.navigation),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _onRouteEvent(RouteEvent value) {
    log('RouteEvent: $value');
  }
}
