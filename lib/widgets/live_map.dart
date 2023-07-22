import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:parking/application/cubits/location_cubit.dart';
import 'package:parking/domain/models/user_locations.dart';
import 'package:latlong2/latlong.dart';

import '../constants.dart';

class LiveMap extends StatelessWidget {
  const LiveMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            minZoom: 6,
            maxZoom: 18,
            zoom: 10,
            center: AppConstants.myLocation,
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
      ],
    );
  }
}
