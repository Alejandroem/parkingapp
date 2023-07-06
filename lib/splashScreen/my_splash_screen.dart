import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors:
              [Colors.lightBlueAccent,
               Colors.teal,
              ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
        )
      ),
        child: Center(
          child: Text(
              'My Car Application',
              style: Theme.of(context)
              .textTheme
              .headlineLarge
          )

        )
    ),
    );

  }

}


