class ApiDefribilateur_response {
  int? gid;
  String? etatValid;
  String? nom;
  double? xCoor2;
  double? yCoor2;
  double? latCoor1;
  double? longCoor1;
  double? xyPrecis;
  String? idAdr;
  String? adrNum;
  String? adrVoie;
  String? comCp;
  String? comNom;

  ApiDefribilateur_response({
    this.gid,
    this.etatValid,
    this.nom,
    this.xCoor2,
    this.yCoor2,
    this.latCoor1,
    this.longCoor1,
    this.xyPrecis,
    this.idAdr,
    this.adrNum,
    this.adrVoie,
    this.comCp,
    this.comNom,
  });

  factory ApiDefribilateur_response.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      var firstItem = json[0];
      return ApiDefribilateur_response(
        gid: firstItem['gid'],
        etatValid: firstItem['etat_valid'],
        nom: firstItem['nom'],
        xCoor2: firstItem['x_coor2'],
        yCoor2: firstItem['y_coor2'],
        latCoor1: firstItem['lat_coor1'],
        longCoor1: firstItem['long_coor1'],
        xyPrecis: firstItem['xy_precis'],
        idAdr: firstItem['id_adr'],
        adrNum: firstItem['adr_num'],
        adrVoie: firstItem['adr_voie'],
        comCp: firstItem['com_cp'],
        comNom: firstItem['com_nom'],
      );
    } else {
      throw Exception("Empty JSON array provided");
    }
  }

  List<dynamic> toJson() {
    List<dynamic> list = [];
    Map<String, dynamic> itemData = {
      'gid': gid,
      'etat_valid': etatValid,
      'nom': nom,
      'x_coor2': xCoor2,
      'y_coor2': yCoor2,
      'lat_coor1': latCoor1,
      'long_coor1': longCoor1,
      'xy_precis': xyPrecis,
      'id_adr': idAdr,
      'adr_num': adrNum,
      'adr_voie': adrVoie,
      'com_cp': comCp,
      'com_nom': comNom,
    };
    list.add(itemData);
    return list;
  }
}
