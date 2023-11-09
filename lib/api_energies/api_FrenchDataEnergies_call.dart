

import 'dart:async';
import 'dart:convert';

import 'package:http_client_helper/http_client_helper.dart';
import 'package:geolocator/geolocator.dart';
import '../api_energies/api_FrenchDataEnergies_response.dart';



class ApiFranceCarburants {

  late final double? _latitude;
  late final double? _longitude;
  late final String? msg;
  late final int? isLoaded;



  Future<APIResponse?> FrenchDataEnergiesApi() async {

  print ("******************* Api 0");

    /// step 0 : get user position

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print(e);
    }

    print ("----------_latitude $_latitude");
    print ("----------_longitude $_longitude");


    CancellationToken? cancellationToken;

    /// step 1 : prepare query url

    //example = "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=prix-des-carburants-en-france-flux-instantane-v2&q=&facet=carburants_disponibles&facet=carburants_indisponibles&facet=horaires_automate_24_24&facet=services_service&geofilter.distance=48.883086%2C2.379072%2C50000";

    String baseUrl = "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=prix-des-carburants-en-france-flux-instantane-v2";
    String facet = "facet=carburants_disponibles&facet=carburants_indisponibles&facet=horaires_automate_24_24&facet=services_service";
    String lang = "lang=fr";
    String units = "units=metric";
    String q = "q";
    String carb_dispo = "facet=carburants_disponibles";
    String carb_indispo = "facet=carburants_indisponibles";
    String horaires = "facet=horaires_automate_24_24";
    String services = "facet=services_service";
    String geofilter = "geofilter.distance=";
    String caracter = "%2C";
    String distance = "50000";
    String msg = "";
    String _lat = _latitude.toString();
    String _lon = _longitude.toString();

    cancellationToken = CancellationToken();

    String _uri = "$baseUrl&$geofilter$_lat$caracter$_lon$caracter$distance";

    print ("----------uri $_uri");


    /// step 2 : get json file from url

   final uri = Uri.parse(_uri);

   final call = await get(uri);

    print (call.body);



    /// step 3 : map the json file

    Map<String, dynamic> map = json.decode(call.body);
    

    /// step 4 : return the answer

    return APIResponse.fromJson(map);


  }

}




