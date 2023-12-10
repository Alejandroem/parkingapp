import 'dart:developer';

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

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  bg.State state = await bg.BackgroundGeolocation.ready(
    bg.Config(
      reset:
          false, // <-- lets the Settings screen drive the config rather than re-applying each boot.
      // Convenience option to automatically configure the SDK to post to Transistor Demo server.
      //transistorAuthorizationToken: token,
      // Logging & Debug
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      // Geolocation options
      desiredAccuracy: bg.Config.ACTIVITY_TYPE_AUTOMOTIVE_NAVIGATION,
      distanceFilter: 1.0,
      // Activity recognition options
      stopTimeout: 5,
      locationAuthorizationRequest: "Always",
      backgroundPermissionRationale: bg.PermissionRationale(
          title:
              "Allow {applicationName} to access this device's location even when the app is closed or not in use.",
          message:
              "This app collects location data to enable recording your trips to work and calculate distance-travelled.",
          positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
          negativeAction: 'Cancel'),
      // HTTP & Persistence
      autoSync: true,
      // Application options
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      heartbeatInterval: 60,
      activityRecognitionInterval: kDebugMode ? 500 : 10000,
    ),
  );

  log('[ready] ${state.toMap()}');
  log('[didDeviceReboot] ${state.didDeviceReboot}');

  if (state.schedule!.isNotEmpty) {
    bg.BackgroundGeolocation.startSchedule();
  }

  if (state.enabled) {
    log('Background location tracking enabled');
  }

  if (state.isMoving ?? false) {
    log("User is moving");
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
            )..requestPermissionsAndStartTracking(),
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
