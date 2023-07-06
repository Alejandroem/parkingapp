import 'dart:async';
import 'package:flutter/material.dart';

class DemoFutureBuilder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DemoFutureBuilder();
}

class _DemoFutureBuilder extends State<DemoFutureBuilder> {
  var _displayText = 'Hello World';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: helloWorldAsync(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('=============== Snapshot no data ==========');
            return CircularProgressIndicator();
          }

          print('=============== Snapshot has data ==========');
          return Column(
            children: <Widget>[
              Text("snapshot.data"),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextButton(
                  child: Text('Pure & Clean Refresh'),
                  onPressed: () {
                    setState(() {
                      _displayText = 'Goodbye Cruel World';
                    });
                  },
                ),
              )
            ],
          );
        });
  }

  Future<String> helloWorldAsync() async {
    return Future<String>.delayed(Duration(seconds: 3)).then((_) {
      return _displayText;
    });
  }
}