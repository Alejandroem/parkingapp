class Documents {
  final int? id;
  final int? numero;
  final int? code;
  final String? societe;
  final String? nom;
  final String? adresse1;
  final String? adresse2;
  final String? code_postal;
  final String? ville;
  final String? region;
  final String? pays;
  final String? email;
  final String? tel;
  final String? tel2;
  final String? date_debut;
  final String? date_fin;
  final String? commentaire;
  final String? image;

  const Documents(
       {this.id,
        this.numero,
        this.code,
        this.societe,
        this.nom,
        this.adresse1,
        this.adresse2,
        this.code_postal,
        this.ville,
        this.region,
        this.pays,
        this.email,
        this.tel,
        this.tel2,
        this.date_debut,
        this.date_fin,
        this.commentaire,
        this.image});

  factory Documents.fromMap(Map<String, dynamic> json) =>
        Documents(
        id: json["id"],
        numero: json["numero"],
        code: json["code"],
        societe: json["societe"],
        nom: json["nom"],
        adresse1: json["adresse1"],
        adresse2: json["adresse2"],
        code_postal: json["code_postal"],
        ville: json["ville"],
        region: json["region"],
        pays: json["pays"],
        email: json["email"],
        tel: json["tel"],
        tel2: json["tel2"],
        date_debut: json["date_debut"],
        date_fin: json["date_fin"],
        commentaire: json["commentaire"],
        image: json["image"]
        );

 Map<String, dynamic> toMap() {
   return {
      'id': id,
      'numero': numero,
      'code': code,
      'societe': societe,
      'nom': nom,
      'adresse1': adresse1,
      'adresse2': adresse2,
      'code_postal': code_postal,
      'ville': ville,
      'region': region,
      'pays': pays,
      'email': email,
      'tel': tel,
      'tel2': tel2,
      'date_debut': date_debut,
      'date_fin': date_fin,
      'commentaire': commentaire,
      'image': image,
    };
  }

}

