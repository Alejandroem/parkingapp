//Table 1 : Informations paiements
class Parkings {
  final int? id;
  final int? auto;
  final double? latitude;
  final double? longitude;
  final String? adresse1;
  final String? adresse2;
  final String? code_postal ;
  final String? ville;
  final String? region;
  final String? pays;
  final String? date_debut;
  final String? date_fin;

  const Parkings(
      {this.id,
      this.auto, 
      this.latitude, 
      this.longitude, 
      this.adresse1, 
      this.adresse2,
      this.code_postal, 
      this.ville, 
      this.region, 
      this.pays, 
      this.date_debut, 
      this.date_fin
      });

  factory Parkings.fromMap(Map<String, dynamic> map) =>
      Parkings(
        id: map["id"],
        auto: map["auto"],
        latitude: map["latitude"],
        longitude: map["longitude"],
        adresse1: map["adresse1"],
        adresse2: map["adresse2"],
        code_postal: map["code_postal"],
        ville: map["ville"],
        region: map["region"],
        pays: map["pays"],
        date_debut: map["date_debut"],
        date_fin: map["date_fin"]
      );

  Map<String, dynamic> toMap() {
    return {
    'id': id,
    'auto': auto,
    'latitude': latitude,
    'longitude': longitude,
    'adresse1': adresse1,
    'adresse2': adresse2,
    'code_postal': code_postal,
    'ville': ville,
    'region': region,
    'pays': pays,
    'date_debut': date_debut,
    'date_fin': date_fin
    };
   }

}



