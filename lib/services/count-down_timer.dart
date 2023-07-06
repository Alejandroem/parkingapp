import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:numberpicker/numberpicker.dart';
import '../constants.dart';
import '../text_FR.dart';


class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

final _countDownController = CountDownController();

class _CountDownTimerState extends State<CountDownTimer> {

  int _durationChoice = 60;
  DateTime _InitialTime =  DateTime.now();
  DateTime _NewTime = DateTime.now();

  static const List<String> list = <String>['Zone Bleue', 'Place Livraison'];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        title: const Text('Timer'),
        backgroundColor: color_background2,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                      style: TextStyle_large),
                  );
                }).toList(),
              ),

              /*
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {

                },
                child: const Text('Zone Bleue'),
              ),
              const SizedBox(height: 30, width:30),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {

                },
                child: const Text('Place Livraison'),
              ),

               */

            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: CircularCountDownTimer(
              controller: _countDownController,
              duration: _durationChoice*60,
              isReverse: true,
              fillColor: color_background2,
              height: 230,
              width: 230,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              isReverseAnimation: true,
              ringColor: kgreyColor,
              autoStart: false,
              textStyle: TextStyle_verylarge,
              onComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Finished',
                    style: smallTextStyle,
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  backgroundColor: kblueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // padding: const EdgeInsets.only(left: 20, top: 20),
                ));
              },

            ),
          ),

          const SizedBox(height: 40),

          Text('Démarré à : ' + _InitialTime.hour.toString() + ' h ' + _InitialTime.minute.toString().padLeft(2, "0"), style: Theme.of(context).textTheme.headline6),

          if (_NewTime > _InitialTime) Text('re-démarré à : ' + _NewTime.hour.toString() + ' h ' + _NewTime.minute.toString().padLeft(2, "0") , style: Theme.of(context).textTheme.headline6) else Text(""),

          const SizedBox(height: 40),

          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(width: 2, color: Colors.deepPurple)),
            child: Column(

              children: [

                SizedBox(height: 20),

                NumberPicker(
                  value: _durationChoice,
                  minValue: 15,
                  maxValue: 120,
                  step: 15,
                  itemHeight: 60,
                  axis: Axis.horizontal,
                  onChanged: (value) =>
                      setState(() => _durationChoice = value),
                  textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 21),
                  selectedTextStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.deepPurple ,fontSize: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                ),

                SizedBox(height: 20),
                Text('Durée choisie $_durationChoice minutes',  style: TextStyle(fontSize: 18,  fontStyle: FontStyle.italic,),),
                SizedBox(height: 16),
              ],
            ),
          ),

          SizedBox(height: 20),

          //Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //  children: [
          //    Button(
          //        text: 'Restart',
          //        onPressed: () => _countDownController.start()),
          //    Button(
          //        text: 'Pause', onPressed: () => _countDownController.pause()),
          //    Button(
          //        text: 'Reprise',
          //        onPressed: () => _countDownController.resume()),
          //   ],
          // ) ,

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
            SizedBox(
              height: 50,
              width: 140,
              child: TextButton(
                style: TextButton.styleFrom(
                  elevation: 12,
                  primary: Colors.white,
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  setState(() {
                    _countDownController.restart(
                        duration: _durationChoice * 60);
                    _NewTime = DateTime.now();
                  });

                  print('Pressed a venir');
                },
                child: Text(
                  'Demmarer',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

              SizedBox(
                height: 50,
                width: 10,
              ),

              SizedBox(
                height: 50,
                width: 140,
                child: TextButton(
                  style: TextButton.styleFrom(
                    elevation: 12,
                    primary: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    setState(() {
                      _countDownController.restart(
                          duration: _durationChoice * 60);
                      _NewTime = DateTime.now();
                    }
                    );

                    print('Pressed a venir');
                  },
                  child: Text(
                    'Relancer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ]

          ),

        ],
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
