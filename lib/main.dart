import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:background_fetch/background_fetch.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_page.dart';
import 'package:mycar/Providers/screenIndexProvider.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _init() async {
    // Android
    if (Platform.isAndroid) {

      if (await Permission.activityRecognition.request().isGranted) {
        ////
      } else {
        /////
      }

      if (await Permission.location.request().isGranted) {
        ////
      } else {
        /////
      }

      if (await Permission.camera.request().isGranted) {
        ////
      } else {
        /////
      }

    }
    // iOS
    else if (Platform.isIOS) { }
  }


    @override
  Widget build(BuildContext context) {
    // empecher la rotation de l'écran
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //
    return MultiProvider(
      child: MaterialApp(
              // to hide debug banner
              debugShowCheckedModeBanner: false,
              // to modify the theme
              title: 'My Car Application',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Colors.deepPurple, error: Colors.red)
                .copyWith(secondary: Colors.deepPurple),
                ),
               home: HomePage(),
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => screenIndexProvider())
      ],
    );
  }
}
