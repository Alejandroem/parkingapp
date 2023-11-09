import 'dart:async';
import 'dart:convert';
import 'package:http_client_helper/http_client_helper.dart';

import 'package:geolocator/geolocator.dart';

import '../api_energies/api_FrenchBornes_response.dart';

class ApiFranceBornes {
  double? _latitude;
  double? _longitude;
  String? msg;
  int? isLoaded;

  CancellationToken? cancellationToken;

  Future<List?> FrenchBornesRequest() async {
    print("Liste bornes------------------");

    late List<Bornes> listBornes;

    /// step 0 : get user position

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      print(e);
    }

    print("----------_latitude $_latitude");
    print("----------_longitude $_longitude");

    /// step 1 : create the url string
    // baseUrl = "https://www.mycarapp.fr:8443/mca/bornes?48.8739087,2.3174906,20";

    String baseUrl = "https://www.mycarapp.fr:8443/mca/bornes";
    String _lat = _latitude.toString();
    String _lon = _longitude.toString();
    int number = 20; // number of points adresses desired to be returned

    String _uri = "$baseUrl?$_lat,$_lon,$number";

    /// step 2 : get data from the server

    cancellationToken = CancellationToken();

    final uri = Uri.parse(_uri);

    final response = await get(uri);

    print("response body");
    print(response.body);

    print("******************** LISTE json.decode() 1 ***************");

    /// Step 1 : json.decode()
    List<dynamic> listeJson = json.decode(response.body);

    /// Step 2 : convert to a List
    listBornes = listeJson.map((item) => Bornes.fromJson(item)).toList();

    /// Print to test
    for (var e in listBornes) {
      print('Distance: ${e.distance}, Nom: ${e.nom_station}');
    }

    print("isLoaded = $isLoaded");

    return listBornes;
  }
}

/// example of JSON answer:
/*
adresse_station	"11 Rue d'Astorg 75008 Paris "
distance	"242 m"
gratuit	"False"
implantation_station	"Voirie"
nom_station	"Paris | Rue d'Astorg 11"
paiement_acte	"True"
paiement_autre	"True"
paiement_cb	"True"
prise_type_2	"True"
prise_type_autre	"False"
prise_type_chademo	"False"
prise_type_combo_ccs	"False"
prise_type_ef	"True"
puissance_nominale	"7"
station_deux_roues	"False"
tarification	"https://belib.paris"
 */
