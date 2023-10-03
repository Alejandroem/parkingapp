import 'package:flutter/material.dart';

class YouAreDrivingPage extends StatelessWidget {
  const YouAreDrivingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'You are driving',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
