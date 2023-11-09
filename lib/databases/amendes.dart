//Table 5 : Amendes
class Amendes {
  final int? id;
  final String? numero;
  final int? pv_payed;
  final String? pv_type;
  final String? telepaiement_no;
  final String? telepaiement_cle;
  final String? date_debut;
  final String? date_intermediaire;
  final String? date_fin;
  final String? adresse1;
  final String? adresse2;
  final String? image;

  const Amendes(
      {this.id,
        this.numero,
        this.pv_payed,
        this.pv_type,
        this.telepaiement_no,
        this.telepaiement_cle,
        this.date_debut,
        this.date_intermediaire,
        this.date_fin,
        this.adresse1,
        this.adresse2,
        this.image
      });

  factory Amendes.fromMap(Map<String, dynamic> map) =>
      Amendes(
          id: map["id"],
          numero: map["numero"],
          pv_payed: map["pv_payed"],
          pv_type: map["pv_type"],
          telepaiement_no: map["telepaiement_no"],
          telepaiement_cle: map["telepaiement_cle"],
          date_debut: map["date_debut"],
          date_fin: map["date_fin"],
          date_intermediaire: map["date_intermediaire"],
          adresse1: map["adresse1"],
          adresse2: map["adresse2"],
          image: map["image"]
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'pv_payed': pv_payed,
      'pv_type': pv_type,
      'telepaiement_no': telepaiement_no,
      'telepaiement_cle': telepaiement_cle,
      'date_debut': date_debut,
      'date_fin': date_fin,
      'date_intermediaire': date_intermediaire,
      'adresse1': adresse1,
      'adresse2': adresse2,
      'image': image
    };
  }

}



