import 'dart:io';
import 'package:mycar/databases/amendes.dart';
import 'package:mycar/databases/permis.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../databases/documents.dart';
import '../databases/contacts.dart';
import '../databases/parking.dart';
import '../databases/vehicules.dart';

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
        bluetooth TEXT,
        econnect INTEGER,
        residentiel_in INTEGER,
        residentiel_code TEXT,
        residentiel_zone TEXT,
        residentiel_datetime TEXT,
        parking_datetime TEXT,
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
        date_fin TEXT
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
    // await db.rawDelete('DELETE from vehicule');
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

    await db.insert('contact', {"libelle": "Moi"});
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
      "plaque": "FR-544-HA",
      "model": "Zoe",
      "vin": "VF1AG000565195782",
      "api_email": "matthieu.desquerre@gmail.com",
      "api_password": "E123341.toi",
      "econnect": 1,
      "groupe": "1",
      "marque": "1",
      "residentiel_in": 1,
      "residentiel_code": "8H,8J,8K,8F",
      "residentiel_zone ":
          "[[48.867504, 2.299248], [48.873383, 2.295423], [48.875076, 2.309177], [48.876483, 2.307869], [48.880376, 2.308952], [48.881295, 2.316480], [48.877898, 2.326919], [48.875537, 2.326559], [48.873731, 2.327058], [48.872732, 2.326608], [48.869601, 2.325870], [48.869500, 2.325149], [48.868992, 2.325321], [48.865094, 2.322432], [48.870565, 2.305298], [48.867504, 2.299248]]",
      "residentiel_datetime": DateTime.now().toString(),
      "last_lattitude": 48.8740326,
      "last_longitude": 2.3165568,
      "last_adresse": "23 rue la Boetie - 75008 Paris",
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
