

import 'dart:convert';
import 'package:http/http.dart';
import '../services/location_service.dart';
import 'api_FrenchControleTechnique_response.dart';


class ApiControleTechnique {

//  https://data.economie.gouv.fr/api/records/1.0/search/?dataset=controle_techn&q=&sort=cct_code_dept&facet=cct_code_dept&facet=code_postal&facet=cct_code_commune&facet=cct_denomination&facet=cat_vehicule_libelle&facet=cat_energie_libelle&facet=prix_visite&facet=prix_contre_visite_min&facet=prix_contre_visite_max&refine.cat_energie_libelle=Diesel&refine.cat_vehicule_libelle=4+x+4&geofilter.distance=48.873928%2C2.317462%2C5000
  String query1 = "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=controle_techn&q=&lang=FR&rows=20&sort=prix_visite&facet=cct_code_dept&facet=code_postal&facet=cct_code_commune&facet=cct_denomination&facet=cat_vehicule_libelle&facet=cat_energie_libelle&facet=prix_visite&facet=prix_contre_visite_min&facet=prix_contre_visite_max&geofilter.distance=48.873895%2C2.317489%2C5000";
  String baseUrl = "https://data.economie.gouv.fr/api/records/1.0/search/?dataset=controle_techn";
  String row    = "20";
  String q      = "";
  String lang   = "FR";
  String sort   = "prix_visite";
  String facet0 = "cct_code_dept";
  String facet1 = "code_postal";
  String facet2 = "cct_code_commune";
  String facet3 = "cct_denomination";
  String facet4 = "cat_vehicule_libelle";
  String facet5 = "cat_energie_libelle";
  String facet6 = "prix_visite";
  String facet7 = "prix_contre_visite_min";
  String facet8 = "prix_contre_visite_max";
  String refine0 = "Diesel";
  String refine1 = "4+x+4";
  String geofilter = "";
  String caracter  = "";
  String distance  = "5000";

  String prepareQuery(GeoPosition geoPosition) {
    final geoLat = geoPosition.lat.toStringAsFixed(6);
    final geoLon = geoPosition.lon.toStringAsFixed(6);
    return "$baseUrl&$q=q&lang=$lang&rows=$row&sort=$sort&facet=$facet0&facet=$facet1&facet=$facet2&facet=$facet3&facet=$facet4&facet=$facet5&facet=$facet6&facet=$facet7&facet=$facet8&refine.cat_energie_libelle=$refine0&refine.cat_vehicule_libelle=$refine1&geofilter.distance=$geoLat%2C$geoLon%2C$distance";
  }


  Future<APIResponse> ControleTechniqueApi(GeoPosition position) async {
    final queryString = prepareQuery(position);

   // queryString = https://data.economie.gouv.fr/api/records/1.0/search/?dataset=controle_techn&=q&lang=FR&rows=20&sort=prix_visite&facet=cct_code_dept&facet=code_postal&facet=cct_code_commune&facet=cct_denomination&facet=cat_vehicule_libelle&facet=cat_energie_libelle&facet=prix_visite&facet=prix_contre_visite_min&facet=prix_contre_visite_max&geofilter.distance=48.873928%2C2.317462%2C5000
   // map         = https://data.economie.gouv.fr/api/records/1.0/search/?dataset=controle_techn&=q&lang=FR&rows=20&sort=prix_visite&facet=cct_code_dept&facet=code_postal&facet=cct_code_commune&facet=cct_denomination&facet=cat_vehicule_libelle&facet=cat_energie_libelle&facet=prix_visite&facet=prix_contre_visite_min&facet=prix_contre_visite_max&geofilter.distance=48.873928%2C2.317462%2C5000


    final uri = Uri.parse(queryString);
    final call = await get(uri);

    Map<String, dynamic> map = json.decode(call.body);

    return APIResponse.fromJson(map);
  }

}


