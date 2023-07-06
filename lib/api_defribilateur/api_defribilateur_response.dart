class ApiDefribilateur_response {
  int? gid;
  String? etatValid;
  String? nom;
  int? xCoor2;
  int? yCoor2;
  int? latCoor1;
  int? longCoor1;
  int? xyPrecis;
  String? idAdr;
  String? adrNum;
  String? adrVoie;
  String? comCp;
  String? comInsee;
  String? comNom;
  String? acc;
  bool? accLib;
  bool? accPcsec;
  bool? accAcc;
  String? accEtg;
  String? accComplt;
  String? photo1;
  String? photo2;
  List<String>? dispJ;
  List<String>? dispH;
  String? dispComplt;
  String? tel1;
  String? tel2;
  String? siteEmail;
  String? dateInstal;
  String? etatFonct;
  String? fabSiren;
  String? fabRais;
  String? mntSiren;
  String? mntRais;
  String? modele;
  String? numSerie;
  String? idEuro;
  bool? lcPed;
  String? dtprLcped;
  String? dtprLcad;
  String? dtprBat;
  String? freqMnt;
  bool? dispsurv;
  String? dermnt;
  String? majDon;
  String? exptSiren;
  String? exptSiret;
  String? exptType;
  String? exptRais;
  String? exptNum;
  String? exptVoie;
  String? exptCom;
  String? exptInsee;
  String? exptCp;
  String? exptTel1;
  String? exptTel2;
  String? exptEmail;
  String? etat;

  ApiDefribilateur_response(
      {this.gid,
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
        this.comInsee,
        this.comNom,
        this.acc,
        this.accLib,
        this.accPcsec,
        this.accAcc,
        this.accEtg,
        this.accComplt,
        this.photo1,
        this.photo2,
        this.dispJ,
        this.dispH,
        this.dispComplt,
        this.tel1,
        this.tel2,
        this.siteEmail,
        this.dateInstal,
        this.etatFonct,
        this.fabSiren,
        this.fabRais,
        this.mntSiren,
        this.mntRais,
        this.modele,
        this.numSerie,
        this.idEuro,
        this.lcPed,
        this.dtprLcped,
        this.dtprLcad,
        this.dtprBat,
        this.freqMnt,
        this.dispsurv,
        this.dermnt,
        this.majDon,
        this.exptSiren,
        this.exptSiret,
        this.exptType,
        this.exptRais,
        this.exptNum,
        this.exptVoie,
        this.exptCom,
        this.exptInsee,
        this.exptCp,
        this.exptTel1,
        this.exptTel2,
        this.exptEmail,
        this.etat});

  ApiDefribilateur_response.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    etatValid = json['etat_valid'];
    nom = json['nom'];
    xCoor2 = json['x_coor2'];
    yCoor2 = json['y_coor2'];
    latCoor1 = json['lat_coor1'];
    longCoor1 = json['long_coor1'];
    xyPrecis = json['xy_precis'];
    idAdr = json['id_adr'];
    adrNum = json['adr_num'];
    adrVoie = json['adr_voie'];
    comCp = json['com_cp'];
    comInsee = json['com_insee'];
    comNom = json['com_nom'];
    acc = json['acc'];
    accLib = json['acc_lib'];
    accPcsec = json['acc_pcsec'];
    accAcc = json['acc_acc'];
    accEtg = json['acc_etg'];
    accComplt = json['acc_complt'];
    photo1 = json['photo1'];
    photo2 = json['photo2'];
    dispJ = json['disp_j'].cast<String>();
    dispH = json['disp_h'].cast<String>();
    dispComplt = json['disp_complt'];
    tel1 = json['tel1'];
    tel2 = json['tel2'];
    siteEmail = json['site_email'];
    dateInstal = json['date_instal'];
    etatFonct = json['etat_fonct'];
    fabSiren = json['fab_siren'];
    fabRais = json['fab_rais'];
    mntSiren = json['mnt_siren'];
    mntRais = json['mnt_rais'];
    modele = json['modele'];
    numSerie = json['num_serie'];
    idEuro = json['id_euro'];
    lcPed = json['lc_ped'];
    dtprLcped = json['dtpr_lcped'];
    dtprLcad = json['dtpr_lcad'];
    dtprBat = json['dtpr_bat'];
    freqMnt = json['freq_mnt'];
    dispsurv = json['dispsurv'];
    dermnt = json['dermnt'];
    majDon = json['maj_don'];
    exptSiren = json['expt_siren'];
    exptSiret = json['expt_siret'];
    exptType = json['expt_type'];
    exptRais = json['expt_rais'];
    exptNum = json['expt_num'];
    exptVoie = json['expt_voie'];
    exptCom = json['expt_com'];
    exptInsee = json['expt_insee'];
    exptCp = json['expt_cp'];
    exptTel1 = json['expt_tel1'];
    exptTel2 = json['expt_tel2'];
    exptEmail = json['expt_email'];
    etat = json['etat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['etat_valid'] = this.etatValid;
    data['nom'] = this.nom;
    data['x_coor2'] = this.xCoor2;
    data['y_coor2'] = this.yCoor2;
    data['lat_coor1'] = this.latCoor1;
    data['long_coor1'] = this.longCoor1;
    data['xy_precis'] = this.xyPrecis;
    data['id_adr'] = this.idAdr;
    data['adr_num'] = this.adrNum;
    data['adr_voie'] = this.adrVoie;
    data['com_cp'] = this.comCp;
    data['com_insee'] = this.comInsee;
    data['com_nom'] = this.comNom;
    data['acc'] = this.acc;
    data['acc_lib'] = this.accLib;
    data['acc_pcsec'] = this.accPcsec;
    data['acc_acc'] = this.accAcc;
    data['acc_etg'] = this.accEtg;
    data['acc_complt'] = this.accComplt;
    data['photo1'] = this.photo1;
    data['photo2'] = this.photo2;
    data['disp_j'] = this.dispJ;
    data['disp_h'] = this.dispH;
    data['disp_complt'] = this.dispComplt;
    data['tel1'] = this.tel1;
    data['tel2'] = this.tel2;
    data['site_email'] = this.siteEmail;
    data['date_instal'] = this.dateInstal;
    data['etat_fonct'] = this.etatFonct;
    data['fab_siren'] = this.fabSiren;
    data['fab_rais'] = this.fabRais;
    data['mnt_siren'] = this.mntSiren;
    data['mnt_rais'] = this.mntRais;
    data['modele'] = this.modele;
    data['num_serie'] = this.numSerie;
    data['id_euro'] = this.idEuro;
    data['lc_ped'] = this.lcPed;
    data['dtpr_lcped'] = this.dtprLcped;
    data['dtpr_lcad'] = this.dtprLcad;
    data['dtpr_bat'] = this.dtprBat;
    data['freq_mnt'] = this.freqMnt;
    data['dispsurv'] = this.dispsurv;
    data['dermnt'] = this.dermnt;
    data['maj_don'] = this.majDon;
    data['expt_siren'] = this.exptSiren;
    data['expt_siret'] = this.exptSiret;
    data['expt_type'] = this.exptType;
    data['expt_rais'] = this.exptRais;
    data['expt_num'] = this.exptNum;
    data['expt_voie'] = this.exptVoie;
    data['expt_com'] = this.exptCom;
    data['expt_insee'] = this.exptInsee;
    data['expt_cp'] = this.exptCp;
    data['expt_tel1'] = this.exptTel1;
    data['expt_tel2'] = this.exptTel2;
    data['expt_email'] = this.exptEmail;
    data['etat'] = this.etat;
    return data;
  }
}