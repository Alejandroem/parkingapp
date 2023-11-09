import 'dart:async';
import 'dart:convert';
import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:geocoding/geocoding.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http_client_helper/http_client_helper.dart';

import '../constants.dart';



class screen5_my_vehicule extends StatefulWidget {
  const screen5_my_vehicule(
  { super.key,
    this.androidDrawer,
    required this.constructeur,
    required this.api_email,
    required this.api_password,
    required this.vin,
    required this.marque,
    required this.modele,
  });

    final Widget? androidDrawer;
    final String constructeur;
    final String api_email;
    final String api_password;
    final String vin;
    final String marque;
    final String modele;


  @override
  _my_vehiculeState createState() => _my_vehiculeState();
}

class _my_vehiculeState extends State<screen5_my_vehicule> {

  CancellationToken? cancellationToken;

  bool isLoading = false;
  bool isLoaded = false;

  String msg = '';

  var info_Total_Mileage;
  var info_Remaining_Range;
  var info_Is_Battery_On_Charge;
  var info_Battery_Autonomy;
  var info_Battery_pct;
  var info_Battery_Level;
  var info_Fuel_Autonomy;
  var info_Gps_Latitude;
  var info_Gps_Longitude;
  var info_LastUpdate_Time;
  var address;

  /*
  Future<Person> _loadPerson() async {
    // Load the JSON file from assets
    String jsonString = await rootBundle.loadString('assets/data.json');

    // Convert JSON string to Map<String, dynamic>
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Create a Person object from the JSON data
    Person person = Person.fromJson(jsonData);

    return person;
  }
*/

  Future<Vehicule> ConstructeurRequest() async {

   isLoading = true;

    ///* step 1 : get data from the api

    print('-------------------------------/ ConstructeurRequest 1--------------------------------------');

    String _urlPrefix = "https://www.mycarapp.fr:8443";
    String _urlPath = "/mca/constructeurs";
    String _id0 = "/1";
    String _id1 = "matthieu.desquerre@gmail.com";
    String _id2 = "E123341.toi";
    String _id3 = "VF1AG000565195782";

    String url0 ="https://www.mycarapp.fr:8443/mca/constructeurs/1?matthieu.desquerre@gmail.com,E123341.toi,VF1AG000565195782";
              // "https://pjb.acme-sas.com/mca/constructeurs/1/?matthieu.desquerre@gmail.com,E123341.toi,VF1AG000565195782";


   String _url = "$_urlPrefix$_urlPath$_id0?$_id1,$_id2,$_id3";

   print('-------------------------------/ _url--------------------------------------');
   print (_url);


   final Uri url = Uri.parse(_url);

   msg = 'begin request';

   print('-------------------------------/ msg--------------------------------------');
   print(msg);

   cancellationToken = CancellationToken();
    try {
      await HttpClientHelper.get(
        url,
        cancelToken: cancellationToken,
        timeRetry: const Duration(milliseconds: 100),
        retries: 3,
        timeLimit: const Duration(seconds: 200),
      ).then((Response? response) {
       // setState(() {
          msg = response!.body;
          print('************************************');
          print ('reponse positive recue du serveur');
          print('************************************');
          print(msg);
          print('************************************');
          isLoading = false;
          isLoaded = true;
       // });
      });
    } on TimeoutException catch (_) {
      setState(() {
        msg = 'TimeoutException';
      });
    } on OperationCanceledError catch (_) {
      setState(() {
        msg = 'cancel';
      });
    } catch (e) {
      setState(() {
        msg = '$e';
      });
    }


    /// Step 2 : convert the json data to object

/*
    // Load the JSON file from assets
    String jsonString = await rootBundle.loadString('assets/data.json');

    // Convert JSON string to Map<String, dynamic>
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Create a Person object from the JSON data
    Person person = Person.fromJson(jsonData);

    return person;
 */

    print('***************Convert JSON string to Map<String, dynamic>*********************');

    // Convert JSON string to Map<String, dynamic>
    print ('******************** msg = ');
    print (msg!);

    print('---------------------------  / informations 1');
    Map<String, dynamic> jsonData = jsonDecode(msg);

    // Create a Vehicule object from the JSON data
    Vehicule vehicule = Vehicule.fromJson(jsonData);

    info_Total_Mileage = vehicule.Total_Mileage.toString();
    info_Remaining_Range = vehicule.Remaining_Range.toString();
    info_Is_Battery_On_Charge = (vehicule.Is_Battery_On_Charge.toString() ==0) ? "Oui" : "Non";
    info_Battery_Autonomy = vehicule.Battery_Autonomy.toString();
    info_Battery_pct = vehicule.Battery_Level.toInt()/100;
    info_Battery_Level = vehicule.Battery_Level.toString();
    info_Fuel_Autonomy = vehicule.Fuel_Autonomy.toString();
    info_Gps_Latitude = vehicule.Gps_Latitude.toString();
    info_Gps_Longitude = vehicule.Gps_Longitude.toString();
    info_LastUpdate_Time = vehicule.Last_Update_Time.toString();

    print('---------------------------  / informations 1');
    print (vehicule.Total_Mileage);
    print (vehicule.Remaining_Range);
    print (vehicule.Is_Battery_On_Charge);
    print (vehicule.Battery_Autonomy);
    print (vehicule.Battery_Level);
    print (vehicule.Fuel_Autonomy);
    print('---------------------------  informations 1 /');
    print (info_Total_Mileage);
    print (info_Remaining_Range);
    print (info_Is_Battery_On_Charge);
    print (info_Battery_Autonomy);
    print (info_Battery_Level);
    print (info_Fuel_Autonomy);
    print(info_Gps_Latitude);
    print(info_Gps_Longitude);
    print(info_LastUpdate_Time);


    /// Step 3 return the object

    return vehicule;

  }



  @override
  void initState() {
    print ('---------------------ConstructeurRequest ----');
    ConstructeurRequest();
    super.initState();
  }

/*
  void cancel() {
    cancellationToken?.cancel();
  }

*/

/*
       Text('Name: ${snapshot.data!.Battery_Autonomy}'),
       Text('Age: ${snapshot.data!.Total_Mileage}'),
       Text('Email: ${snapshot.data!.Is_Battery_On_Charge}'),

 */

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: (isLoaded == false)
            ? Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text ("Nous interrogeons le constructeur \n afin d'obtenir les informations \n sur votre véhicule",
                        style: TextStyle_large,
                        textAlign: TextAlign.center,
                       ),
                  UpDownLoader(
                    size: 12,
                    firstColor : Colors.teal,
                    secondColor : Colors.black,
                    //  duration: Duration(milliseconds: 600),
                  ),
                ],
              ),
            )
        )

           : Container(
               color: Colors.white,
                child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              height: (size.height / 2) - 90,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: color_background,
                                border: Border.all(color: color_border),
                                borderRadius: BorderRadius.circular(border_radius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   // SizedBox(height: 5.0),
                                    Text("Votre batterie :", style: TextStyle_large),
                                   // SizedBox(height: 5.0),
                                    CircularPercentIndicator(
                                      radius: 105.0,
                                      lineWidth: 13.0,
                                      animation: true,
                                      percent: info_Battery_pct, //0.7,
                                      center: new Text(
                                        "$info_Battery_Level %",
                                        style: TextStyle_verylarge,
                                      ),
                                      circularStrokeCap: CircularStrokeCap.round,
                                      progressColor: Colors.teal,
                                    ),
                                    // SizedBox(height: 20.0),
                                    Text('Autonomie: $info_Remaining_Range kilomètres',
                                        style: TextStyle_regular),
                                  ]),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              height: (size.height / 3) - 40,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: color_background,
                                border: Border.all(color: color_border),
                                borderRadius: BorderRadius.circular(border_radius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    Text("Check List", style: TextStyle_regular),
                                    const SizedBox(height: 10.0),
                                    Text("Batterie en charge : $info_Is_Battery_On_Charge",
                                        style: TextStyle_regular),
                                    const SizedBox(height: 10.0),
                                    Text("Kilométrage : $info_Total_Mileage",
                                        style: TextStyle_regular),
                                    const SizedBox(height: 10.0),
                                       // Text("Prochaine révision : juillet 2023",
                                        Text("$info_Gps_Latitude - $info_Gps_Longitude",
                                        style: TextStyle_regular),
                                    const SizedBox(height: 10.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        print("ok");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: color_background2,
                                        elevation: 10,
                                        shadowColor: Colors.white,
                                      ),
                                      child: Text("Mettre en marche la Clim",
                                          style: TextStyle_button),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      elevation: 7.5,
                      //color: Colors.teal,
                      margin: EdgeInsets.all(5),
                    )
                )
              ),
    ),
    );

  }

  Future<void> convertCoordinatesToAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
         info_Gps_Latitude,info_Gps_Longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String formattedAddress = "${placemark.street}, ${placemark.locality}, ${placemark.country}";
        setState(() {
          address = formattedAddress;
        });
      }
    } catch (e) {
      setState(() {
        address = "Erreur : $e";
      });
    }
  }
}


class Vehicule {
  final int Battery_Autonomy;
  final int Battery_Level;
  final double Fuel_Autonomy;
  final double Is_Battery_On_Charge;
  final double Gps_Latitude;
  final double Gps_Longitude;
  final String Last_Update_Time;
  final double Remaining_Range;
  final double Total_Mileage;


  const Vehicule({
    required this.Battery_Autonomy,
    required this.Battery_Level,
    required this.Fuel_Autonomy,
    required this.Is_Battery_On_Charge,
    required this.Gps_Latitude,
    required this.Gps_Longitude,
    required this.Last_Update_Time,
    required this.Remaining_Range,
    required this.Total_Mileage,
  });

  factory Vehicule.fromJson(Map<String, dynamic> json) {
    return Vehicule(
      Battery_Autonomy: json['Battery_Autonomy'],
      Battery_Level: json['Battery_Level'],
      Fuel_Autonomy: json['Fuel_Autonomy'],
      Is_Battery_On_Charge: json['Is_Battery_On_Charge'],
      Remaining_Range: json['Remaining_Range'],
      Gps_Latitude: json['Gps_Latitude'],
      Gps_Longitude: json['Gps_Longitude'],
      Last_Update_Time: json['Last_Update_Time'],
      Total_Mileage: json['Total_Mileage'],
    );
  }
}


/// example

/*
{
"name": "John Doe",
"age": 30,
"email": "john.doe@example.com"
}
*/

class Person {
  final String name;
  final int age;
  final String email;

  Person({required this.name, required this.age, required this.email});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }
}

