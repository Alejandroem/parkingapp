import 'package:flutter/material.dart';
import '../constants.dart';



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
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: color_background2,
              border: Border.all(color: color_border),
              borderRadius: BorderRadius.circular(border_radius),
              ),
          child:
          Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment : CrossAxisAlignment.center,
            children:  [

                  Text('Développement en cours',
                       style: TextStyle_regular_white),

                  SizedBox(
                          height:50,
                          width:100,
                          child:
                          TextButton(
                            style: TextButton.styleFrom(
                              elevation: 12,
                              primary: Colors.teal,
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () => Navigator.of(context).pop(),

                            child: Text ('Ok', style: TextStyle(fontSize: 24),),
                          ),
                        ),


                      ],



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
