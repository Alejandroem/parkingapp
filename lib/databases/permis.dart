//Table 5 : Permis
class Permis {
  final int? id;
  final String? numero;
  final String? code1;
  final String? code2;
  final String? code3;
  final String? code_consultation;
  final String? categorie;
  final String? date_debut;
  final String? date_fin;

  const Permis(
      {this.id,
       this.numero,
       this.code1,
       this.code2,
       this.code3,
       this.code_consultation,
       this.categorie,
       this.date_debut,
       this.date_fin

      });

  factory Permis.fromMap(Map<String, dynamic> map) =>
      Permis(
          id: map["id"],
          numero: map["numero"],
          code1: map["code1"],
          code2: map["code2"],
          code3: map["code3"],
          code_consultation: map["code_consultation"],
          categorie: map["categorie"],
          date_debut: map["date_debut"],
          date_fin: map["date_fin"]
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'code1': code1,
      'code2': code2,
      'code3': code3,
      'code_consultation': code_consultation,
      'categorie': categorie,
      'date_debut': date_debut,
      'date_fin': date_fin
    };
  }

}



