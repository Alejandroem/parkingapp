

import 'dart:convert';
import 'package:http/http.dart';
import '../services/location_service.dart';
import 'api_FrenchDataEnergies_response_old.dart';


class ApiFranceCarburants {

  String query1 = "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=prix-des-carburants-en-france-flux-instantane-v2&q=&facet=carburants_disponibles&facet=carburants_indisponibles&facet=horaires_automate_24_24&facet=services_service&geofilter.distance=48.883086%2C2.379072%2C50000";

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
  String distance = "5000";

  String prepareQuery(GeoPosition geoPosition) {
    final geoLat = geoPosition.lat;
    final geoLon = geoPosition.lon;
   // return "$baseUrl&$q&$facet&$geofilter$geoLat$caracter$geoLon$caracter$distance";
    return "$baseUrl&$geofilter$geoLat$caracter$geoLon$caracter$distance";
  }


  Future<APIResponse> FrenchDataEnergiesApi(GeoPosition position) async {
    final queryString = prepareQuery(position);
    print (queryString);
    final uri = Uri.parse(queryString);
    final call = await get(uri);
    Map<String, dynamic> map = json.decode(call.body);
    print(map);
    return APIResponse.fromJson(map);
  }

}


