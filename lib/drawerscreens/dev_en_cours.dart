import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:numberpicker/numberpicker.dart';
import '../constants.dart';
import '../text_FR.dart';


class DevEnCours extends StatefulWidget {
  const DevEnCours({Key? key}) : super(key: key);

  @override
  State<DevEnCours> createState() => _DevEnCoursState();
}

class _DevEnCoursState extends State<DevEnCours> {


  int selectedIndex = 1;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        title: const Text('A venir'),
        backgroundColor: color_background2,
      ),
      body: Center(
        child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: color_background,
              border: Border.all(color: color_border),
              borderRadius: BorderRadius.circular(border_radius),
              ),
          child:
          IndexedStack (
            alignment: Alignment.center,
            index: this.selectedIndex,
                  children: <Widget> [
                    Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(height: 60),

                        Text('Développement en cours',
                            style: TextStyle_regular),

                        SizedBox(height: 40),

                        SizedBox(
                          height:50,
                          width:100,
                          child:
                          TextButton(
                            style: TextButton.styleFrom(
                              elevation: 12,
                              primary: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () => Navigator.of(context).pop(),

                            child: Text ('Ok', style: TextStyle(fontSize: 24),),
                          ),
                        ),

                        SizedBox(
                          height:50,
                          width:100,
                          child:
                          TextButton(
                            style: TextButton.styleFrom(
                              elevation: 12,
                              primary: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () => Navigator.of(context).pop(),

                            child: Text ('Changer', style: TextStyle(fontSize: 24),),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),]

                ),

              ),
      ),

    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const Button({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: smallTextStyle,
        ));
  }
}
