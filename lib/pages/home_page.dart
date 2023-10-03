import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/domain/services/location_service.dart';

import '../application/cubits/movement_cubit.dart';
import '../application/cubits/navigation_cubit.dart';
import '../widgets/navigation_map.dart';
import '../widgets/parking_map.dart';
import '../widgets/you_are_driving_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NavigationCubit, AppPage>(
          builder: (context, page) {
            switch (page) {
              case AppPage.map:
                return const NavigationMap();
              case AppPage.parking:
                return FutureBuilder(
                  future: context.read<LocationService>().getLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return BlocBuilder<MovementCubit, MovementState>(
                          builder: (context, state) {
                            if (state.lastParkedLocation != null &&
                                state.lastParkedTime != null) {
                              return ParkingMap(state.lastParkedLocation!);
                            }
                            return const YouAreDrivingPage();
                          },
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
            }
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, AppPage>(
        builder: (context, page) {
          return BottomNavigationBar(
            currentIndex: page.index,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.read<NavigationCubit>().showMapPage();
                  break;
                case 1:
                  context.read<NavigationCubit>().showParkingPage();
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "Map",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_parking),
                label: "Parking",
              ),
            ],
          );
        },
      ),
    );
  }
}
