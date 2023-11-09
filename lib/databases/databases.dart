
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../databases/documents.dart';
import '../databases/contacts.dart';
import '../databases/vehicules.dart';
import '../databases/permis.dart';
import '../databases/amendes.dart';

class DatabaseClient {
  ///*
  ///  Initialisation, Création, Suppression, Modification des TABLES
  ///

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await getDatabase();
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'MyCarDb.db');
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  onCreate(Database database, int version) async {
    //Table contact :
    await database.execute('''
        CREATE TABLE contact (
        id INTEGER PRIMARY KEY,
        code INTEGER,
        libelle TEXT,
        societe TEXT,
        poste TEXT,
        lastname TEXT,
        firstname TEXT,
        sexe TEXT,
        adresse1 TEXT,
        adresse2 TEXT,
        code_postal TEXT,
        ville TEXT,
        region TEXT,
        pays TEXT,
        email TEXT,
        tel TEXT,
        tel2 TEXT,
        insta TEXT,
        tweeter TEXT,
        facebook TEXT,
        date_birth TEXT,
        paybyphone_cookie INTEGER,
        mairie_paris_cookie INTEGER,
        image TEXT
        )
        ''');

    //Table 2 : vehicules
    await database.execute('''
        CREATE TABLE vehicules (
        id INTEGER PRIMARY KEY,
        plaque TEXT,
        vin TEXT,
        groupe TEXT,
        marque TEXT,
        model TEXT,
        kilometre TEXT,
        date_achat TEXT,
        api_email TEXT,
        api_password TEXT,
        api_account_id TEXT,
        api_account_pass TEXT,
        carburant TEXT,
        last_lattitude REAL,
        last_longitude REAL,
        last_adresse TEXT,
        last_datetime TEXT,
        garage INTEGER,
        bluetooth INTEGER,
        econnect INTEGER,
        residentiel_in INTEGER,
        residentiel_code TEXT,
        residentiel_zone TEXT,
        date_resident TEXT,
        date_visiteur TEXT,
        date_handi TEXT,
        image TEXT
        )
        ''');

    //Table 3 : documents
    await database.execute('''
        CREATE TABLE documents (
        id INTEGER PRIMARY KEY,
        numero INT, 
        code INT, 
        societe TEXT, 
        nom TEXT,
        adresse1 TEXT,
        adresse2 TEXT,
        code_postal TEXT,
        ville TEXT,
        region TEXT,
        pays TEXT,
        email TEXT,
        tel TEXT,
        tel2 TEXT,
        date_debut TEXT,
        date_fin TEXT,
        commentaire TEXT,
        image TEXT
        )
        ''');

    //Table 4 : parking
    await database.execute('''
        CREATE TABLE parking (
        id INTEGER PRIMARY KEY,
        auto INTEGER,
        latitude REAL,
        longitude REAL,
        adresse1 TEXT,
        adresse2 TEXT,
        code_postal TEXT,
        ville TEXT,
        region TEXT,
        pays TEXT,
        date_debut TEXT,
        date_fin TEXT
        )
        ''');

    //Table 5 : amendes
    await database.execute('''
        CREATE TABLE amendes (
        id INTEGER PRIMARY KEY,
        numero TEXT,      
        pv_payed INTEGER,
        pv_type TEXT,
        telepaiement_no TEXT,
        telepaiement_cle TEXT,
        date_debut TEXT,
        date_reduction TEXT,
        date_fin TEXT,
        adresse1 TEXT,
        adresse2 TEXT,
        image TEXT
        )
        ''');

    //Table 5 : permis
    await database.execute('''
        CREATE TABLE permis (
        id INTEGER PRIMARY KEY,
        numero TEXT,        
        code1 TEXT,
        code2 TEXT,
        code3 TEXT, 
        code_consultation TEXT,
        categorie TEXT,
        date_debut TEXT,
        date_fin TEXT
        )
        ''');

    initializeData();
  }

  // supprimer les données
  Future<bool> TablesAllRawDelete() async {
    final Database db = await database;
    await db.rawDelete('DELETE from contact');
    await db.rawDelete('DELETE from vehicules');
    await db.rawDelete('DELETE from documents');
    await db.rawDelete('DELETE from parking');
    return true;
  }

  //intialiser  les données
  Future<bool> initializeData() async {
    final Database db = await database;

    // await db.rawDelete('DELETE from contact');
    // await db.rawDelete('DELETE from vehicules');
    // await db.rawDelete('DELETE from documents');
    // await db.rawDelete('DELETE from parking');

    await db.insert('documents', {"nom": "Permis de conduire", "code": 1});
    await db.insert('documents', {"nom": "Carte Grise", "code": 1});
    await db.insert('documents', {"nom": "Assurance", "code": 1});
    await db.insert('documents', {"nom": "Controle Technique", "code": 1});
    await db.insert('documents', {"nom": "Carré vert", "code": 0});
    await db.insert('documents', {"nom": "Vignette Controle T.", "code": 0});
    await db.insert('documents', {"nom": "Vignette Crit'Air", "code": 1});
    await db.insert('documents', {"nom": "FPS", "code": 2});
    await db.insert('documents', {"nom": "Plein carburant", "code": 2});
    await db.insert('documents', {"nom": "Révision véhicule", "code": 2});

    await db.insert('contact', {
      "libelle": "Moi",
      "societe": "",
      "poste": "",
      "lastname": "BELLAVOINE",
      "firstname": "Pierre-Jean",
      "sexe": "M.",
      "adresse1": "17 B rue la Boetie",
      "adresse2": "",
      "code_postal": "75008",
      "ville": "Paris",
      "region": "Ile de France",
      "pays": "France",
      "email": "pierrejean75@gmail.com",
      "tel": "+33619568376",
      "tel2": "",
      "paybyphone_cookie": 0,
      "mairie_paris_cookie": 0
    });

    await db.insert('contact', {
      "libelle": "Mon Assureur",
      "societe": "Paris-Tronchet",
      "poste": "Commercial",
      "lastname": "ARISTILDE",
      "firstname": "Pradel",
      "sexe": "M.",
      "adresse1": "103 rue de Miromesnil",
      "adresse2": "",
      "code_postal": "75008",
      "ville": "Paris",
      "region": "Ile de France",
      "pays": "France",
      "email": "commercial@paristronchet.fr",
      "tel": "+33140070399",
      "tel2": "+33140071306"
    });
    await db.insert('contact', {
      "libelle": "Mon Garage",
      "societe": "ZeRide",
      "poste": "Commercial",
      "lastname": "",
      "firstname": "",
      "sexe": "",
      "adresse1": "63 Bd Malesherbes",
      "adresse2": "",
      "code_postal": "75008",
      "ville": "Paris",
      "region": "Ile de France",
      "pays": "France",
      "email": "centreparis8@zeride.fr",
      "tel": "+33158050512",
    });
    await db.insert('contact', {
      "libelle": "Mon Assistance",
      "societe": "Europe Assistance",
      "poste": "",
      "lastname": "DUPOND",
      "firstname": "Damien",
      "sexe": "M.",
      "adresse1": "11-17 Av. François Mitterrand",
      "adresse2": "",
      "code_postal": "93210",
      "ville": "Saint-Denis",
      "region": "Ile de France",
      "pays": "France",
      "email": "relation.clients@europ-assistance.fr",
      "tel": "+01 41 85 85 85",
      "tel2": ""
    });
    await db.insert('contact', {
      "libelle": "Mon Médecin",
      "societe": "",
      "poste": "",
      "lastname": "AUGIER",
      "firstname": "Ghislaine",
      "sexe": "Mme",
      "adresse1": "8 rue Royale",
      "adresse2": "",
      "code_postal": "75002",
      "ville": "Paris",
      "region": "Ile de France",
      "pays": "France",
      "email": "ghislaine.m.augier@gmail.com",
      "tel": "+33147126751",
      "tel2": "+33608466344"
    });
    await db.insert('contact', {"libelle": "Police", "tel": "17"});
    await db.insert('contact', {"libelle": "Pompier", "tel": "18"});
    await db.insert('contact', {"libelle": "Samu", "tel": "15"});
    await db.insert('contact', {"libelle": "Dépanneur"});
    await db.insert('contact', {"libelle": "Ami 1", "tel": "+33619568376"});
    await db.insert('contact', {"libelle": "Ami 2", "tel": "+33619568376"});


    await db.insert('vehicules', {
      "plaque": "FR544HA",
      "groupe": "1",
      "marque": "Renault",
      "model": "Zoe",
      "vin": "VF1AG000565195782",
      "api_email": "matthieu.desquerre@gmail.com",
      "api_password": "E123341.toi",
      "bluetooth": 1,
      "econnect": 1,
      "carburant": "electricity",
      "residentiel_in": 1,
      "residentiel_code": "8G,8J,17J,17K",
      "residentiel_zone ": "[[48.877754, 2.297942], [48.876728, 2.297194], [48.876275, 2.296865], [48.875851, 2.296555], [48.875439, 2.296257], [48.875335, 2.296181], [48.875124, 2.296027], [48.874441, 2.29553], [48.874323, 2.295443], [48.874249, 2.295391], [48.874147, 2.295316], [48.874106, 2.295287], [48.87396, 2.295179], [48.873783, 2.295052], [48.873851, 2.296143], [48.873975, 2.29728], [48.874082, 2.298302], [48.874159, 2.298941], [48.874233, 2.299606], [48.874418, 2.301286], [48.874518, 2.302202], [48.874659, 2.303487], [48.874793, 2.304712], [48.874857, 2.305361], [48.874885, 2.305747], [48.875013, 2.308678], [48.875026, 2.309029], [48.875022, 2.309146], [48.874628, 2.309558], [48.874562, 2.309644], [48.874391, 2.309871], [48.874238, 2.310047], [48.873892, 2.310597], [48.873556, 2.310976], [48.873358, 2.311199], [48.873073, 2.311522], [48.873295, 2.3123], [48.873669, 2.314487], [48.873739, 2.314899], [48.87391, 2.3159], [48.874185, 2.31751], [48.874373, 2.318617], [48.874514, 2.319444], [48.874539, 2.31959], [48.874754, 2.319975], [48.874953, 2.319725], [48.875289, 2.319302], [48.875604, 2.318923], [48.876318, 2.318069], [48.876627, 2.317698], [48.877765, 2.316305], [48.878374, 2.315565], [48.87899, 2.314808], [48.87942, 2.314291], [48.879654, 2.314007], [48.880083, 2.313488], [48.880475, 2.313012], [48.880813, 2.312583], [48.881152, 2.315351], [48.881179, 2.315569], [48.881274, 2.316344], [48.881279, 2.316385], [48.881294, 2.316514], [48.881383, 2.316415], [48.882084, 2.315626], [48.882387, 2.315286], [48.882685, 2.314949], [48.882847, 2.314767], [48.883642, 2.313855], [48.883748, 2.313733], [48.883784, 2.31366], [48.88511, 2.310901], [48.885376, 2.310352], [48.885628, 2.31002], [48.885948, 2.309598], [48.885444, 2.308025], [48.885234, 2.307374], [48.883977, 2.305104], [48.883771, 2.304886], [48.883819, 2.304614], [48.884182, 2.302922], [48.88406, 2.302554], [48.883257, 2.301968], [48.8822, 2.301192], [48.882158, 2.301161], [48.882066, 2.301095], [48.8817, 2.300831], [48.881552, 2.300722], [48.880971, 2.300299], [48.880662, 2.300079], [48.880332, 2.299837], [48.87972, 2.299371], [48.87888, 2.298766], [48.878534, 2.298516], [48.878074, 2.298172], [48.877823, 2.297993], [48.877754, 2.297942]]",
      "last_lattitude": 48.88246946770146,
      "last_longitude": 2.3078547543281744,
      "last_adresse": "23 rue Henri Rochefort - 75017 Paris",
      "last_datetime": DateTime.now().toString(),
    });

    await db.insert('vehicules', {
      "plaque": "EB558DY",
      "groupe": "2",
      "marque": "Peugeot",
      "model": "Metropolis",
      "vin": "",
      "api_email": "",
      "api_password": "",
      "bluetooth": 0,
      "econnect": 0,
      "carburant": "e10",
      "residentiel_in": 1,
      "residentiel_code": "8H,8J,8K,8F",
      "residentiel_zone ": "[[48.875013, 2.308678], [48.874885, 2.305747], [48.874857, 2.305361], [48.874793, 2.304712], [48.874659, 2.303487], [48.874518, 2.302202], [48.874418, 2.301286], [48.874233, 2.299606], [48.874159, 2.298941], [48.874082, 2.298302], [48.873975, 2.29728], [48.873851, 2.296143], [48.873783, 2.295052], [48.873695, 2.295127], [48.873674, 2.295145], [48.873471, 2.295322], [48.87347, 2.295324], [48.873432, 2.295356], [48.873272, 2.295496], [48.873157, 2.295596], [48.87249, 2.296178], [48.871114, 2.29738], [48.870975, 2.297501], [48.870973, 2.297503], [48.870933, 2.297533], [48.869711, 2.298249], [48.869621, 2.298302], [48.868569, 2.298918], [48.868403, 2.298967], [48.867467, 2.299251], [48.867947, 2.300214], [48.868258, 2.300816], [48.868425, 2.30115], [48.868723, 2.301734], [48.869194, 2.30266], [48.869247, 2.302771], [48.870536, 2.305293], [48.870739, 2.305802], [48.870154, 2.306478], [48.870093, 2.306665], [48.8699, 2.307264], [48.869877, 2.307335], [48.869281, 2.309178], [48.868978, 2.310113], [48.868718, 2.310988], [48.868275, 2.312373], [48.867788, 2.31385], [48.867533, 2.314666], [48.86709, 2.316065], [48.866144, 2.319019], [48.865872, 2.319889], [48.864958, 2.322532], [48.86553, 2.322977], [48.866103, 2.323422], [48.86633, 2.323439], [48.866424, 2.323512], [48.866493, 2.323565], [48.866496, 2.323568], [48.866901, 2.323855], [48.867307, 2.324141], [48.867661, 2.324391], [48.867712, 2.324427], [48.86791, 2.324567], [48.867924, 2.324577], [48.86793, 2.324581], [48.867931, 2.324582], [48.868053, 2.324669], [48.86858, 2.325027], [48.869006, 2.325317], [48.869442, 2.325157], [48.86953, 2.325685], [48.869555, 2.325833], [48.870558, 2.326091], [48.871255, 2.326272], [48.872124, 2.326496], [48.872496, 2.326593], [48.872978, 2.326718], [48.873126, 2.326756], [48.873265, 2.326853], [48.873721, 2.327056], [48.873802, 2.326772], [48.874165, 2.326941], [48.87482, 2.326773], [48.875337, 2.326639], [48.875539, 2.326588], [48.875555, 2.326857], [48.875608, 2.326852], [48.877195, 2.326925], [48.877824, 2.326953], [48.87891, 2.323618], [48.879064, 2.323174], [48.879445, 2.322043], [48.879506, 2.321831], [48.879587, 2.321556], [48.879825, 2.320867], [48.879859, 2.320719], [48.879891, 2.320572], [48.880115, 2.319943], [48.880339, 2.319226], [48.880615, 2.318404], [48.880861, 2.317657], [48.881104, 2.316912], [48.881294, 2.316514], [48.881279, 2.316385], [48.881274, 2.316344], [48.881179, 2.315569], [48.881152, 2.315351], [48.880813, 2.312583], [48.880699, 2.311649], [48.880459, 2.309643], [48.880399, 2.309155], [48.880377, 2.309026], [48.880161, 2.309073], [48.8799, 2.309178], [48.879458, 2.309239], [48.878226, 2.308403], [48.877848, 2.308316], [48.877417, 2.308193], [48.87733, 2.308166], [48.876586, 2.307976], [48.876534, 2.307954], [48.876328, 2.30793], [48.875397, 2.308831], [48.875183, 2.309037], [48.875022, 2.309146], [48.875026, 2.309029], [48.875013,2.308678]]",
      "last_lattitude": 48.874215,
      "last_longitude": 2.317233,
      "last_adresse": "17 b rue la Boetie - 75008 Paris",
      "last_datetime": DateTime.now().toString(),
    });

    await db.insert('amendes', {
      "numero": "6467951949",
      "pv_payed": 0,
      "pv_type": "Amende",
      "telepaiement_no": "33364679519491",
      "telepaiement_cle": "17",
      "date_debut": "2023-05-23",
      "date_fin": "2023-07-07",
    });

    await db.insert('amendes', {
      "numero": "6105412965",
      "pv_payed": 1,
      "pv_type": "FPS",
      "telepaiement_no": "33361054129651",
      "telepaiement_cle": "18",
      "date_debut": "2018-10-23",
      "date_fin": "2018-12-07",
    });

    await db.insert('amendes', {
      "numero": "6417100434",
      "pv_payed": 0,
      "pv_type": "FPS",
      "telepaiement_no": "33364171004341",
      "telepaiement_cle": "92",
      "date_debut": "2023-06-20",
      "date_fin": "2023-08-04",
    });

    await db.insert('permis', {
      "numero": "800978200032",
      "code1": "800978200032",
      "code2": "",
      "code3": "",
      "code_consultation": "PZ5XQZC7",
      "categorie": "B",
      "date_debut": "1981-02-05",
      "date_fin": "",
    });

    await db.insert('permis', {
      "numero": "800978200032",
      "code_consultation": "PZ5XQZC7",
      "categorie": "A",
      "date_debut": "1981-02-05",
      "date_fin": "",
    });

    return true;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  //supprime les tables
  Future<bool> DeleteTables() async {
    Database db = await database;
    await db.execute("DROP TABLE IF EXISTS contact");
    await db.execute("DROP TABLE IF EXISTS auto");
    await db.execute("DROP TABLE IF EXISTS documents");
    await db.execute("DROP TABLE IF EXISTS parking");
    await db.execute("DROP TABLE IF EXISTS vehicules");
    return true;
  }

  Future close() async {
    var dbClient = await database;
    dbClient!.close();
  }

  ///#   TABLE documents
  ///    functions

  Future<List<Documents>> DocumentsList1() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM documents WHERE code < 2",
    );
    return rawQueryResult.map((e) => Documents.fromMap(e)).toList();
  }

  Future<List<Documents>> DocumentsList2() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM documents WHERE code > 0",
    );
    return rawQueryResult.map((e) => Documents.fromMap(e)).toList();
  }

  Future<List<Documents>> DocumentsPictures() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM documents WHERE image IS NOT NULL",
    );
    return rawQueryResult.map((e) => Documents.fromMap(e)).toList();
  }

  Future<bool> DocumentsUpdate(Documents documents, int id) async {
    Database? db = await database;
    await db.update('documents', documents.toMap(),
        where: "id = ?", whereArgs: [documents.id]);
    return true;
  }

  Future<void> DocumentsUpdateDate(int idKey, String datefin) async {
    Database db = await getDatabase();
    db.rawUpdate(
        "UPDATE documents SET date_fin = '$datefin' WHERE id = '$idKey'");
    return;
  }

  Future<void> DocumentsUpdateImage(int idKey, String _image) async {
    Database db = await getDatabase();
    db.rawUpdate("UPDATE documents SET image = '$_image' WHERE id = '$idKey'");
    return;
  }

  Future<void> DocumentsDelete(int idKey) async {
    Database db = await getDatabase();
    await db.rawDelete("DELETE FROM documents WHERE id = '$idKey'");
    return;
  }

  Future<List<Documents>> DocumentsFromId(int id) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> mapList =
        await db.query('documents', where: 'id = ?', whereArgs: [id]);
    return mapList.map((map) => Documents.fromMap(map)).toList();
  }

  Future<bool> DocumentsInsert(Documents documents) async {
    Database? db = await database;
    await db.insert(
      'documents',
      documents.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  ///#   TABLE contact
  ///    functions

  Future<List<Contacts>> ContactsList() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM contact",
    );
    return rawQueryResult.map((e) => Contacts.fromMap(e)).toList();
  }

  Future<List<Contacts>> GetContactInfo(int idKey) async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM contact WHERE id = $idKey",
    );
    return rawQueryResult.map((e) => Contacts.fromMap(e)).toList();
  }

  Future<List<Contacts>> ContactsPictures() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM contact WHERE image IS NOT NULL",
    );
    return rawQueryResult.map((e) => Contacts.fromMap(e)).toList();
  }

  Future<bool> ContactsUpdateDate(
      Contacts contacts, int idKey, String datefin) async {
    Database? db = await database;
    db.rawUpdate("UPDATE contact SET date_fin = datefin WHERE id = idKey");
    return true;
  }

  Future<bool> ContactsUpdateImage(
      Contacts Contacts, int idKey, String _image) async {
    Database? db = await database;
    db.rawUpdate("UPDATE contact SET image = _image WHERE id = idKey");
    return true;
  }

  Future<bool> ContactUpdate(
      int idKey,
      String societe,
      String poste,
      String sexe,
      String lastname,
      String firstname,
      String email,
      String tel,
      String tel2,
      String adresse1,
      String adresse2,
      String code_postal,
      String ville) async {
    Database db = await getDatabase();
    db.rawUpdate(
        "UPDATE contact SET societe = '$societe', poste = '$poste', sexe = '$sexe', lastname = '$lastname', email = '$email', tel = '$tel',  tel2 = '$tel2', adresse1 = '$adresse1', adresse2 = '$adresse2', code_postal = '$code_postal',  ville = '$ville' WHERE id = $idKey");
    return true;
  }

  Future<bool> ContactsDelete(Contacts Contacts) async {
    Database? db = await database;
    await db.delete('contact', where: "id = ?", whereArgs: [Contacts.id]);
    return true;
  }

  Future<List<Contacts>> ContactsFromId(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> mapList =
        await db.query('contact', where: 'id = ?', whereArgs: [id]);
    return mapList.map((map) => Contacts.fromMap(map)).toList();
  }

  Future<bool> ContactsInsert(Contacts Contacts) async {
    Database? db = await database;
    await db.insert(
      'contact',
      Contacts.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  ///#   TABLE vehicule
  ///    functions

  // Future<List<Vehicules>> VehiculeInfo({required int idKey}) async {
  //   final Database db = await database;
  //   final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
  //     "SELECT * FROM vehicules WHERE id = $idKey",
  //   );
  //   return rawQueryResult.map((e) => Vehicules.fromMap(e)).toList();
  // }

  Future<List<Vehicules>> VehiculeInfo({required int idKey}) async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM vehicules WHERE id = $idKey",
    );
    if (rawQueryResult.isNotEmpty) {
      return rawQueryResult.map((e) => Vehicules.fromMap(e)).toList();
    } else {
      // Handle the case when no data is found
      return []; // or you can return null if you prefer
    }
  }

  Future<List<Vehicules>> VehiculesInfo() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM vehicules"
    );
    if (rawQueryResult.isNotEmpty) {
      return rawQueryResult.map((e) => Vehicules.fromMap(e)).toList();
    } else {
      return []; // or you can return null if you prefer
    }
  }

  Future<bool> VehiculeUpdateLoc(
      {required int idKey,
      required double lat,
      required double lon,
      required String adr,
      required String datetime}) async {
    Database db = await getDatabase();
    db.rawUpdate(
        "UPDATE vehicules SET last_lattitude = '$lat', last_longitude = '$lon', last_adresse = '$adr', last_datetime = '$datetime' WHERE id = '$idKey'");
    return true;
  }

  Future<bool> VehiculeUpdatePayments(
      {required int idKey,
        required String payment_resident,
        required String payment_visiteur,
        required String payment_handi,
      }) async {
    Database db = await getDatabase();
    db.rawUpdate(
        "UPDATE vehicules SET date_resident = '$payment_resident', date_visiteur = '$payment_visiteur', date_handi = '$payment_handi' WHERE id = '$idKey'");
    return true;
  }

  Future<List<Documents>> VehiculeList() async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT id,plaque FROM vehicules",
    );
    return rawQueryResult.map((e) => Documents.fromMap(e)).toList();
  }

  ///#   TABLE amandes
  ///    functions

  Future<List<Amendes>> AmendesList({required int idType}) async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      "SELECT * FROM amendes",
    );
    return rawQueryResult.map((e) => Amendes.fromMap(e)).toList();
  }

  ///#   TABLE permis
  ///    functions

  Future<List<Permis>> PermisInfo({required int idKey}) async {
    final Database db = await database;
    final List<Map<String, Object?>> rawQueryResult = await db!.rawQuery(
      // "SELECT * FROM permis WHERE id = $idKey",
      "SELECT * FROM permis",
    );
    return rawQueryResult.map((e) => Permis.fromMap(e)).toList();
  }
}
