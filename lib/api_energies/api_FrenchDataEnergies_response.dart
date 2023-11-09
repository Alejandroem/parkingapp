

class APIResponse {
  int? nhits;
//  Parameters parameters;
  List<ForeCast> records;

  APIResponse(
      this.nhits,
 //     this.parameters,
      this.records
       );

  APIResponse.fromJson(Map<String?, dynamic> map) :
      nhits = map["nhits"],
  //  parameters = map["parameters"],
      records = DataConverter().listMappable(map["records"]).map((e) => ForeCast.fromJson(e)).toList();

}

class ForeCast {
  String? datasetid;
  String? recordid;
 // Parameters parameters;
  Fields fields;
//  List<Prix> prix;
//  List<GeofilterDistance> geofilterDistance;

  ForeCast(
  this.datasetid,
  this.recordid,
 // this.parameters,
  this.fields,
//  this.prix,
 // this.geofilterDistance
      );

  ForeCast.fromJson(Map<String?, dynamic> map) :
        datasetid = map["datasetid"],
        recordid = map["recordid"],
        fields = Fields.fromJson(map["fields"]);
  }

class Fields {
  String? region;
  String? gazole_maj;
  String? gazole_prix;
  String? sp98_maj;
  String? sp98_prix;
  String? e85_maj;
  String? e85_prix;
  String? e10_maj;
  String? e10_prix;
  String? cp;
  String? ville;
  String? carburants_disponibles;
  String? adresse;
  String? latitude;
  String? departement;
  String? carburants_indisponibles;
  double? longitude;
  String? dist;

  Fields(
      this.region,
      this.gazole_maj,
      this.gazole_prix,
      this.sp98_maj,
      this.sp98_prix,
      this.e85_maj,
      this.e85_prix,
      this.e10_maj,
      this.e10_prix,
      this.cp,
      this.ville,
      this.carburants_disponibles,
      this.adresse,
      this.latitude,
      this.departement,
      this.carburants_indisponibles,
      this.longitude,
      this.dist
      );

  Fields.fromJson(Map<String?, dynamic> map) :
        region = map["region"],
        gazole_maj = map["gazole_maj"],
        gazole_prix = map["gazole_prix"],
        sp98_maj = map["sp98_maj"],
        sp98_prix = map["sp98_prix"],
        e85_maj = map["e85_maj"],
        e85_prix = map["e85_prix"],
        e10_maj = map["e10_maj"],
        e10_prix = map["e10_prix"],
        cp = map["cp"],
        ville = map["ville"],
        carburants_disponibles = map["carburants_disponibles"],
        adresse = map["adresse"],
        latitude = map["latitude"],
        departement = map["departement"],
        carburants_indisponibles = map["carburants_indisponibles"],
        longitude = map["longitude"].toDouble(),
        dist = map["dist"];
}

/*

class Services {
String? service;
String? Toilettes_publiques;
String? Boutique_non_alimentaire;
String? Carburant_additive;
String? Lavage_automatique;
String? Services_reparation;
String? entretien;

Services(
    this.services,
    this.Toilettes_publiques,
    this.Boutique_non_alimentaire,
    this.Carburant_additive,
    this.Lavage_automatique,
    this.Services_reparation,
    this.entretien
    );
}

class Prix {
  String? nom;
  String? maj;
  String? valeur;
 
  Prix (
      this.nom,
      this.maj,
      this.valeur
      );

  Prix.fromJson(Map<String?, dynamic> map) :
        nom = map["nom"],
        maj = map["maj"],
        valeur = map["valeur"];
}

class Facet {
  String? carburants_disponibles;
  String? carburants_indisponibles;
  String? horaires_automate_24_24;
  String? services_service;

  Facet (
      this.carburants_disponibles,
      this.carburants_indisponibles,
      this.horaires_automate_24_24,
      this.services_service
      );

  Facet.fromJson(Map<String?, dynamic> map) :
        carburants_disponibles = map["carburants_disponibles"],
        carburants_indisponibles = map["carburants_indisponibles"],
        horaires_automate_24_24 = map["horaires_automate_24_24"],
        services_service = map["services_service"];
}



class GeofilterDistance {
  double lat;
  double lon;

  GeofilterDistance(
      this.lat,
      this.lon
      );

  GeofilterDistance.fromJson(Map<String?, dynamic> map) :
        lat = map["lat"],
        lon = map["lon"];
}


class Geom {
  double lat;
  double lon;

  Geom(
      this.lat,
      this.lon
      );

  Geom.fromJson(Map<String?, dynamic> map) :
        lat = map["lat"],
        lon = map["lon"];
}

class Parameters {
  String? dataset;
  int rows;
  int start;
  String? format;
  String? timezone;

  Parameters (
      this.dataset,
      this.rows,
      this.start,
      this.format,
      this.timezone
      );

  Parameters.fromJson(Map<String?, dynamic> map) :
        dataset = map["dataset"],
        rows = map["rows"],
        start = map["start"],
        format = map["format"],
        timezone = map["timezone"];
}


*/


class DataConverter {
    List<Map<String, dynamic>> listMappable(List<dynamic> records) {
    return records.map((e) => e as Map<String, dynamic>).toList();
  }

}