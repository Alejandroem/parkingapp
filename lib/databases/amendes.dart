//Table 5 : Amendes
class Amendes {
  final int? id;
  final String? numero;
  final int? pv_payed;
  final String? pv_type;
  final String? telepaiement_no;
  final String? telepaiement_cle;
  final String? date_debut;
  final String? date_fin;

  const Amendes(
      {this.id,
        this.numero,
        this.pv_payed,
        this.pv_type,
        this.telepaiement_no,
        this.telepaiement_cle,
        this.date_debut,
        this.date_fin
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
          date_fin: map["date_fin"]
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
      'date_fin': date_fin
    };
  }

}



