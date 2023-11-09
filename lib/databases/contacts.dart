//Table 1 : contact

class Contacts {
  final int? id;
  final int? code;
  final String? libelle;
  final String? societe;
  final String? poste;
  final String? lastname;
  final String? firstname;
  final String? sexe;
  final String? adresse1;
  final String? adresse2;
  final String? code_postal ;
  final String? ville;
  final String? region;
  final String? pays;
  final String? email;
  final String? tel;
  final String? tel2;
  final String? insta;
  final String? tweeter;
  final String? facebook;
  final String? date_birth;
  final String? image;
  final int? paybyphone_cookie;
  final int? mairie_paris_cookie;

 const Contacts(
   {this.id, 
    this.code,
    this.libelle,
    this.societe, 
    this.poste, 
    this.lastname, 
    this.firstname, 
    this.sexe, 
    this.adresse1,
    this.adresse2, 
    this.code_postal, 
    this.ville, 
    this.region, 
    this.pays, 
    this.email,
    this.tel, 
    this.tel2, 
    this.insta, 
    this.tweeter, 
    this.facebook, 
    this.date_birth, 
    this.image,
     this.mairie_paris_cookie,
     this.paybyphone_cookie
   });

 factory Contacts.fromMap(Map<String, dynamic> map) =>
      Contacts( 
        id: map["id"],
        code: map["code"],
        libelle: map["libelle"],
        societe: map["societe"],
        poste: map["poste"],
        lastname: map["lastname"],
        firstname: map["firstname"],
        sexe: map["sexe"],
        adresse1: map["adresse1"],
        adresse2: map["adresse2"],
        code_postal: map["code_postal"],
        ville: map["ville"],
        region: map["region"],
        pays: map["pays"],
        email: map["email"],
        tel: map["tel"],
        tel2: map["tel2"],
        insta: map["insta"],
        tweeter: map["tweeter"],
        facebook: map["facebook"],
        date_birth: map["date_birth"],
        image: map["image"],
        mairie_paris_cookie: map["mairie_paris_cookie"],
        paybyphone_cookie: map["paybyphone_cookie"]
      );

   Map<String, dynamic> toMap() {
     return {
     'id': id,
     'code': code,
     'libelle': libelle,
     'societe': societe,
     'poste': poste,
     'lastname': lastname,
     'firstname': firstname,
     'sexe': sexe,
     'adresse1': adresse1,
     'adresse2': adresse2,
     'code_postal': code_postal,
     'ville': ville,
     'region': region,
     'pays': pays,
     'email': email,
     'tel': tel,
     'tel2': tel2,
     'insta': insta,
     'tweeter': tweeter,
     'facebook': facebook,
     'date_birth': date_birth,
     'image': image,
     'mairie_paris_cookie': mairie_paris_cookie,
     'paybyphone_cookie': paybyphone_cookie
     };
   }




}