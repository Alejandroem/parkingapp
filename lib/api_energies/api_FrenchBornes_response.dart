
class Bornes {
  final String? adresse_station;
  final String? distance;
  final String? gratuit;
  final String? implantation_station;
  final String? nom_station;
  final String? paiement_acte;
  final String? paiement_autre;
  final String? paiement_cb;
  final String? prise_type_2;
  final String? prise_type_autre;
  final String? prise_type_chademo;
  final String? prise_type_combo_ccs;
  final String? prise_type_ef;
  final String? puissance_nominale;
  final String? station_deux_roues;
  final String? tarification;


  Bornes({
    required this.adresse_station,
    required this.distance,
    required this.gratuit,
    required this.implantation_station,
    required this.nom_station,
    required this.paiement_acte,
    required this.paiement_autre,
    required this.paiement_cb,
    required this.prise_type_2,
    required this.prise_type_autre,
    required this.prise_type_chademo,
    required this.prise_type_combo_ccs,
    required this.prise_type_ef,
    required this.puissance_nominale,
    required this.station_deux_roues,
    required this.tarification,
  });

  factory Bornes.fromJson(Map<String, dynamic> json) {
    return Bornes(
      adresse_station: json['adresse_station'],
      distance: json['distance'],
      gratuit: json['gratuit'],
      implantation_station: json['implantation_station'],
      nom_station: json['nom_station'],
      paiement_acte: json['paiement_acte'],
      paiement_autre: json['paiement_autre'],
      paiement_cb: json['paiement_cb'],
      prise_type_2: json['prise_type_2'],
      prise_type_autre: json['prise_type_autre'],
      prise_type_chademo: json['prise_type_chademo'],
      prise_type_combo_ccs: json['prise_type_combo_ccs'],
      prise_type_ef: json['prise_type_ef'],
      puissance_nominale: json['puissance_nominale'],
      station_deux_roues: json['station_deux_roues'],
      tarification: json['tarification'],
    );
  }
}

/*
example of JSON answer:

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

