import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:parking/application/cubits/movement_cubit.dart';
import 'package:parking/domain/services/activity_service.dart';
import 'package:parking/domain/services/directions_service.dart';
import 'package:parking/pages/home_page.dart';

import 'application/cubits/location_cubit.dart';
import 'application/cubits/navigation_cubit.dart';
import 'domain/services/location_service.dart';
import 'domain/services/traffic_service.dart';
import 'infrastructure/device_activity_service.dart';
import 'infrastructure/geolocation_location_service.dart';
import 'infrastructure/mapbox_directions_service.dart';
import 'infrastructure/mapbox_traffic_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TrafficService>(
          create: (context) => MapBoxTrafficService(),
        ),
        RepositoryProvider<LocationService>(
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
              context.read<LocationService>(),
              context.read<DirectionsService>(),
            ),
          ),
          BlocProvider<MovementCubit>(
            create: (context) => MovementCubit(
              context.read<LocationService>(),
              context.read<ActivityService>(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SafeArea(
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}
