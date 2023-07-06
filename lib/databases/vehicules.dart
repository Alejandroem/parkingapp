//Table 1 : Informations client
class Vehicules {
  final int? id;
  final String? plaque;
  final String? vin;
  final String? groupe;
  final String? marque;
  final String? model;
  final String? kilometre;
  final String? date_achat;
  final String? api_email;
  final String? api_password;
  final String? api_account_id;
  final String? api_account_pass;
  final String? carburant;
  final double? last_lattitude;
  final double? last_longitude;
  final String? last_adresse;
  final String? last_datetime;
  final int? garage;
  final String? key_id;
  final String? bluetooth;
  final int? econnect;
  final int? residentiel_in;
  final String? residentiel_code;
  final String? residentiel_zone;
  final String? residentiel_datetime;
  final String? parking_datetime;
  final String? image;

  const Vehicules(
      { this.id,
        this.plaque,
        this.vin,
        this.groupe,
        this.marque,
        this.model,
        this.kilometre,
        this.date_achat,
        this.api_email,
        this.api_password,
        this.api_account_id,
        this.api_account_pass,
        this.carburant,
        this.last_lattitude,
        this.last_longitude,
        this.last_adresse,
        this.last_datetime,
        this.garage,
        this.key_id,
        this.bluetooth,
        this.econnect,
        this.residentiel_in,
        this.residentiel_code,
        this.residentiel_zone,
        this.residentiel_datetime,
        this.parking_datetime,
        this.image});

  factory Vehicules.fromMap(Map<String, dynamic> map) =>
      Vehicules(
          id: map["id"],
          plaque: map["plaque"],
          vin: map["vin"],
          marque: map["marque"],
          groupe: map["groupe"],
          model: map["model"],
          kilometre: map["kilometre"],
          date_achat: map["date_achat"],
          api_email: map["api_email"],
          api_password: map["api_password"],
          api_account_id: map["api_account_id"],
          api_account_pass: map["api_account_pass"],
          carburant: map["carburant"],
          last_lattitude: map["last_lattitude"],
          last_longitude: map["last_longitude"],
          last_adresse: map["last_adresse"],
          last_datetime: map["last_datetime"],
          garage: map["garage"],
          key_id: map["key_id"],
          bluetooth: map["bluetooth"],
          econnect: map["econnect"],
          residentiel_in: map["residentiel_in"],
          residentiel_code: map["residentiel_code"],
          residentiel_zone: map["residentiel_zone"],
          residentiel_datetime: map["residentiel_datetime"],
          parking_datetime: map["parking_datetime"],
          image: map["image"]
      );

  Map<String, dynamic> toMap() {
    return{
      'id' : id,
      'plaque' : plaque,
      'groupe' : groupe,
      'vin' : vin,
      'marque' : marque,
      'model' : model,
      'kilometre' : kilometre,
      'date_achat' : date_achat,
      'api_email' : api_email,
      'api_password' : api_password,
      'api_account_id' : api_account_id,
      'api_account_pass' : api_account_pass,
      'carburant' : carburant,
      'last_lattitude' : last_lattitude,
      'last_longitude' : last_longitude,
      'last_adresse' : last_adresse,
      'last_datetime' : last_datetime,
      'garage' : garage,
      'key_id' : key_id,
      'bluetooth' : bluetooth,
      'econnect' : econnect,
      'residentiel_in' : residentiel_in,
      'residentiel_code' : residentiel_code,
      'residentiel_zone' : residentiel_zone,
      'residentiel_datetime' : residentiel_datetime,
      'parking_datetime' : parking_datetime,
      'image' : image,
    };
  }



}