import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/widgets/parking_browser.dart';

import '../domain/cubits/navigation_cubit.dart';
import '../widgets/live_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NavigationCubit, AppPage>(
          builder: (context, page) {
            switch (page) {
              case AppPage.home:
                return const Placeholder();
              case AppPage.parking:
                return const ParkingBrowser();
              case AppPage.map:
                return const LiveMap();
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
                  context.read<NavigationCubit>().showHomePage();
                  break;
                case 1:
                  context.read<NavigationCubit>().showParkingPage();
                  break;
                case 2:
                  context.read<NavigationCubit>().showMapPage();
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: "Parking",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "Map",
              ),
            ],
          );
        },
      ),
    );
  }
}
