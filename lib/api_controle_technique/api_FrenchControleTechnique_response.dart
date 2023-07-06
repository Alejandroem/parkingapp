
class APIResponse {
  int? nhits;
//  Parameters parameters;
  List<ForeCast> records;

  APIResponse(
      this.nhits,
   // this.parameters,
      this.records,
      );

  APIResponse.fromJson(Map<String?, dynamic> map) :
        nhits = map["nhits"],
  //    parameters = map["parameters"],
        records = DataConverter().listMappable(map["records"]).map((e) => ForeCast.fromJson(e)).toList();

}

class ForeCast {

  String? datasetid;
  String? recordid;
  Fields fields;

  ForeCast(
      this.datasetid,
      this.recordid,
      this.fields,
      );

  ForeCast.fromJson(Map<String?, dynamic> map) :
        datasetid = map["datasetid"],
        recordid  = map["recordid"],
        fields    = Fields.fromJson(map["fields"]);

}

class Fields {
  String? cct_code_commune;
  double? prix_contre_visite_min;
  String? cct_tel;
  String? cat_vehicule_id;
  double? prix_contre_visite_max;
  String? cct_denomination;
 // String? latitude;
  String? cct_url;
  String? cat_energie_id;
  String? cct_adresse;
  String? cct_code_dept;
  String? cat_energie_libelle;
  String? date_application_contre_visite;
  String? code_postal;
  String? cat_vehicule_libelle;
  double? prix_visite;
  String? date_application_visite;
  String? dist;

  Fields(
      this.cct_code_commune,
      this.prix_contre_visite_min,
      this.cct_tel,
      this.cat_vehicule_id,
      this.prix_contre_visite_max,
      this.cct_denomination,
  //    this.latitude,
      this.cct_url,
      this.cat_energie_id,
      this.cct_adresse,
      this.cct_code_dept,
      this.cat_energie_libelle,
      this.date_application_contre_visite,
      this.code_postal,
      this.cat_vehicule_libelle,
      this.prix_visite,
      this.date_application_visite,
      this.dist
      );

  Fields.fromJson(Map<String?, dynamic> map) :
        cct_code_commune = map["cct_code_commune"],
        prix_contre_visite_min = map["prix_contre_visite_min"],
        cct_tel = map["cct_tel"],
        cat_vehicule_id = map["cat_vehicule_id"],
        prix_contre_visite_max = map["prix_contre_visite_max"],
        cct_denomination = map["cct_denomination"],
     //   latitude = map["latitude"],
        cct_url = map["cct_url"],
        cat_energie_id = map["cat_energie_id"],
        cct_adresse = map["cct_adresse"],
        cct_code_dept = map["cct_code_dept"],
        cat_energie_libelle = map["cat_energie_libelle"],
        date_application_contre_visite = map["date_application_contre_visite"],
        cat_vehicule_libelle = map["cat_vehicule_libelle"],
        code_postal = map["code_postal"],
        prix_visite = map["prix_visite"],
        date_application_visite = map["date_application_visite"],
        dist = map["dist"];
}



class DataConverter {
  List<Map<String, dynamic>> listMappable(List<dynamic> records) {
    return records.map((e) => e as Map<String, dynamic>).toList();
  }

}
