import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:parking/application/cubits/location_cubit.dart';
import 'package:parking/application/cubits/movement_cubit.dart';
import 'package:parking/domain/models/user_locations.dart';
import 'package:latlong2/latlong.dart';

import '../constants.dart';
import '../domain/models/lat_lng.dart';

class LiveMap extends StatelessWidget {
  final LatitudeLongitude initialLocation;
  const LiveMap(this.initialLocation, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
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
            onTap: (tapPosition, point) {
              context
                  .read<LocationCubit>()
                  .updateLastTappedLocation(point.latitude, point.longitude);
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
            BlocBuilder<LocationCubit, UserLocation>(
              builder: (context, state) {
                if (state.polylines != null) {
                  List<Polyline> polylines = [];
                  for (int i = 0; i < state.polylines!.length - 1; i++) {
                    polylines.add(
                      Polyline(
                        points: [
                          LatLng(
                            state.polylines![i].latitude,
                            state.polylines![i].longitude,
                          ),
                          LatLng(
                            state.polylines![i + 1].latitude,
                            state.polylines![i + 1].longitude,
                          ),
                        ],
                        strokeWidth: 10.0,
                        color: Colors.blue,
                      ),
                    );
                  }
                  return PolylineLayer(
                    polylines: polylines,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<LocationCubit, UserLocation>(
              builder: (context, state) {
                if (state.currentLocation == null) {
                  return const SizedBox.shrink();
                }
                return MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        state.currentLocation!.latitude,
                        state.currentLocation!.longitude,
                      ),
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<MovementCubit, MovementState>(
              builder: (context, state) {
                return MarkerLayer(
                  markers: [
                    if (state.parkingPlace != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          state.parkingPlace!.location.latitude,
                          state.parkingPlace!.location.longitude,
                        ),
                        builder: (ctx) => Icon(
                          Icons.car_crash_rounded,
                          color: state.parkingPlace!.accuracy == Accuracy.high
                              ? Colors.red
                              : Colors.yellow,
                          size: 40,
                        ),
                      ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        state.lastKnownLocation.latitude,
                        state.lastKnownLocation.longitude,
                      ),
                      builder: (ctx) => const Icon(
                        Icons.directions_car,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<LocationCubit, UserLocation>(
              builder: (context, state) {
                if (state.lastTappedLocation == null) {
                  return const SizedBox.shrink();
                }
                return MarkerLayer(
                  markers: [
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
                        size: 40,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        /* BlocBuilder<MovementCubit, MovementState>(
          builder: (context, state) {
            if (state.speed > 1) {
              return Positioned(
                left: 10,
                bottom: 20,
                child: DottedBorderCircle(
                  radius: 45,
                  fillColor: Colors.black,
                  borderColor: 99 > 100 ? Colors.red : Colors.white,
                  borderWidth: 4,
                  dotSpacing: 2.5,
                  velocity: "${(state.speed).toStringAsFixed(0)} Km/h",
                  maxSpeed: 100,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ) */
      ],
    );
  }
}
