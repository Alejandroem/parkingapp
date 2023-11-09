
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';
import '../Providers/screenIndexProvider.dart';



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
    return MultiProvider(
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
        ChangeNotifierProvider(create: (context) => screenIndexProvider())
      ],
    );
  }
}
