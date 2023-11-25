import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';
import '../Providers/screenIndexProvider.dart';
import 'application/cubits/location_cubit.dart';
import 'application/cubits/movement_cubit.dart';
import 'application/cubits/navigation_cubit.dart';
import 'domain/services/activity_service.dart';
import 'domain/services/directions_service.dart';
import 'domain/services/location_service.dart';
import 'domain/services/traffic_service.dart';
import 'infrastructure/device_activity_service.dart';
import 'infrastructure/geolocation_location_service.dart';
import 'infrastructure/mapbox_directions_service.dart';
import 'infrastructure/mapbox_traffic_service.dart';
import 'services/location_service.dart';

void main() {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fix screen orientation to portrait only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TrafficService>(
          create: (context) => MapBoxTrafficService(),
        ),
        RepositoryProvider<UserLocationService>(
          create: (context) => GeolocationLocationService(),
        ),
        RepositoryProvider<DirectionsService>(
          create: (context) => MapboxDirectionsService(),
        ),
        RepositoryProvider<ActivityService>(
          create: (context) => DeviceActivityService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<LocationCubit>(
            create: (context) => LocationCubit(
              context.read<UserLocationService>(),
              context.read<DirectionsService>(),
            ),
          ),
          BlocProvider<MovementCubit>(
            create: (context) => MovementCubit(
              context.read<UserLocationService>(),
              context.read<ActivityService>(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MultiProvider(
            child: MaterialApp(
              // to hide debug banner
              debugShowCheckedModeBanner: false,
              // to modify the theme
              title: 'My Car Application',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(primary: Colors.teal, error: Colors.red)
                    .copyWith(secondary: Colors.teal),
              ),
              home: HomePage(),
            ),
            providers: [
              ChangeNotifierProvider(
                create: (context) => screenIndexProvider(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
