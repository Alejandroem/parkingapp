import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ParkingInformations());
}

class ParkingInformations extends StatefulWidget {
  @override
  _ParkingInformationsState createState() => _ParkingInformationsState();
}

class _ParkingInformationsState extends State<ParkingInformations> {


  String location = "48.88246946,2.3078547543";
  String _result = "";


  Future<void> _fetchParkingInfo() async {


    final url =
        'https://overpass-api.de/api/interpreter?data=[out:json];(node["amenity"="parking"](around:1000,$location);way["amenity"="parking"](around:1000,$location););out;';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Process the parking information here.
        // You can parse jsonData and display the results as needed.

        setState(() {
          _result = 'Parking information: ${jsonData.toString()}';
          print ("--------------------------1");
          print (_result);
        });
      } else {
        setState(() {
          print ("--------------------------2");
          _result = 'Error: Unable to fetch data from OSM.';
        });
      }
    } catch (e) {
      setState(() {
        print ("--------------------------3");
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
    //    appBar: AppBar(
    //      title: Text('OSM Parking Info'),
    //    ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(location),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchParkingInfo,
                child: Text('Fetch Parking Info'),
              ),
              SizedBox(height: 20),
             ],
          ),
        ),
      ),
    );
  }
}
