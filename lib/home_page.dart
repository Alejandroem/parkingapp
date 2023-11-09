import 'dart:io';

import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:mycar/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'ParkingInfo.dart';
import 'checkspeedcamera.dart';
import 'screen4_electricity.dart';
import '../ForceG.dart';
import '../Providers/screenIndexProvider.dart';
import '../screen1_parking.dart';
import '../screen2_road.dart';
import '../screen5_my_vehicule.dart';
import '../screen4_carburant.dart';
import '../screen3_news.dart';
import '../drawerscreens/parameters.dart';
import '../drawerscreens/accident.dart';
import '../drawerscreens/mesadresses.dart';
import '../drawerscreens/mespapiers.dart';
import '../drawerscreens/defribilateur.dart';
import '../api_controle_technique/api_FrenchControleTechnique_home.dart';
import '../model/dev_en_cours.dart';
import '../constants.dart';
import '../databases/databases.dart';
import '../databases/vehicules.dart';
import '../mespoints/mespoints.dart';
import '../drawerscreens/pannes.dart';
import '../fourrieres/fourriere.dart';

///
/// Version update on 22 september 2023
///

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String _appBarTitle;

  bool statusPermission = false;

  var previousActivity;
  var actualActivity;
  var currentActivity;
  var activityType;
  var CarParkingGeolocalisation;
  var CarParkingAdresse;
  var CarParkingDateTime;
  var CarState = 0;
  var CarSpeed = 0.00;
  var econnect = 0;

  var vehiculesinfos =
      <Vehicules>[]; // All informations on all the vehicules the user has registred

  List<String> vehiculesList =
      []; // List of vehicules for the AppBar Button PopupMenu

  // parameters saved with SharedPreferences
  int userVehiculeId =
      0; // the id of the vehicule the user want to use in the App
  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;
  bool switch4 = false;
  bool switch5 = false;
  bool switch6 = false;
  bool switch7 = false;

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userVehiculeId = prefs.getInt('userVehiculeId') ?? 0;
      switch1 = prefs.getBool('switch1') ?? false;
      switch2 = prefs.getBool('switch2') ?? false;
      switch3 = prefs.getBool('switch3') ?? false;
      switch4 = prefs.getBool('switch4') ?? false;
      switch5 = prefs.getBool('switch5') ?? false;
      switch6 = prefs.getBool('switch6') ?? false;
      switch7 = prefs.getBool('switch7') ?? false;
    });
  }

  Future<void> _saveData(int _defaultvehicule) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userVehiculeId', _defaultvehicule);
  }

  // get car informations
  Future<List<Vehicules>?> getVehiculesInfo() async {
    final fromDb = await DatabaseClient().VehiculesInfo();
    if (fromDb != null) {
      setState(() {
        vehiculesinfos = fromDb;
        vehiculesList = vehiculesMenuItems();
        //  print (vehiculesList);
      });
      return fromDb;
    } else {
      return null;
    }
  }

  // create list of vehicules for AppBar Menu PopuUp to select the vehicule
  List<String> vehiculesMenuItems() {
    List<String> vehicules = [];
    for (var i = 0; i < vehiculesinfos.length; i++) {
      vehicules.add(vehiculesinfos[i].plaque.toString()!);
    }
    vehicules.add('Ajouter');
    vehicules.add('Aide');

    return vehicules;
  }

  // Titles of the 5 basic screens
  final List<String> titleList = [
    "Parking",
    "Maps",
    'Auto News',
    'Carburants',
    'Mon véhicule',
  ];

  // default screen
  int _currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  final _bottomNavigationBarItems_no_econnect = [
    BottomNavigationBarItem(
      icon: Icon(Icons.local_parking, color: color_icone),
      label: 'Parking',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_road, color: color_icone),
      label: 'En route',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.ad_units, color: color_icone),
      label: 'News',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_gas_station, color: color_icone),
      label: 'Carburant',
      backgroundColor: color_texte1,
    ),
  ];

  final _bottomNavigationBarItems_with_econnect = [
    BottomNavigationBarItem(
      icon: Icon(Icons.local_parking, color: color_icone),
      label: 'Parking',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_road, color: color_icone),
      label: 'Route',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.ad_units, color: color_icone),
      label: 'News',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_gas_station, color: color_icone),
      label: 'Carburant',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.drive_eta, color: color_icone),
      label: 'Mon véhicule',
      backgroundColor: color_texte1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    requestPermissions(); // check permissions and if not already allowed ask permissions
    _loadSavedData(); // get data from preferenceShared
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: getVehiculesInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final _screenindexprovider =
              Provider.of<screenIndexProvider>(context);
          int currentScreenIndex = _screenindexprovider.fetchCurrentScreenIndex;
          econnect = vehiculesinfos![0].econnect!;
          return Scaffold(
            appBar: AppBar(
              title: Text(titleList[_currentIndex]),
              backgroundColor: color_background2,
              centerTitle: true,
              elevation: 7.5,
              actions: <Widget>[
                PopupMenuButton(
                  elevation: 20,
                  splashRadius: 15,
                  initialValue: vehiculesList[0].toString(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.yellow,
                  itemBuilder: (context) => vehiculesList
                      .map((e) => PopupMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onSelected: (value) {
                    if (value == "Ajouter") {
                      print(" ------------clic Ajouter");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DevEnCours()));
                    } else if (value == "Aide") {
                      print(" ------------clic Aide");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DevEnCours()));
                    } else {
                      setState(() {
                        userVehiculeId = vehiculesList.indexOf(value, 0);
                        _saveData(userVehiculeId);
                        print(
                            " clic value selected = $value - id = $userVehiculeId");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      });
                    }
                  },
                ),
              ],
            ),
            drawer: _buildDrawer(context),
            body: PageView(
              controller: _pageController,
              onPageChanged: (newIndex) {
                setState(() {
                  _currentIndex = newIndex;
                });
              },
              children: [
                screen1_parking(
                  immatriculation: vehiculesinfos[userVehiculeId].plaque ?? "",
                  bluetooth: vehiculesinfos[userVehiculeId].bluetooth ?? 0,
                  econnect: vehiculesinfos[userVehiculeId].econnect ?? 0,
                  lat: vehiculesinfos[userVehiculeId].last_lattitude ?? 48.873821,
                  lon: vehiculesinfos[userVehiculeId].last_longitude ?? 2.315757,
                  isInZone: vehiculesinfos[userVehiculeId].residentiel_in ?? 0,
                  residential_zone: vehiculesinfos[userVehiculeId].residentiel_zone ?? "",
                  CurrentActivity: 0,
                  expResident: vehiculesinfos[userVehiculeId].date_resident ?? "",
                  expVisiteur: vehiculesinfos[userVehiculeId].date_visiteur ?? "",

                  /// to do : understand why changing vehiculesinfos?[0].date_handi to vehiculesinfos?[userVehiculeId].date_handi create an error !
                  expHandi: vehiculesinfos[0].date_handi ?? "",
                  newcarpark: 0,
                  LastAdresse: vehiculesinfos[userVehiculeId].last_adresse ?? "",
                ),
                screen2_road(
                  lat: vehiculesinfos[userVehiculeId].last_lattitude ?? 48.873821,
                  lon: vehiculesinfos[userVehiculeId].last_longitude ?? 2.315757,
                ),
                screen3_news(),
                if (vehiculesinfos[userVehiculeId].econnect == 0)
                  screen4_carburant(),
                if (vehiculesinfos[userVehiculeId].econnect == 1)
                  screen4_electricity(),
                if (vehiculesinfos[userVehiculeId].econnect == 1)
                  screen5_my_vehicule(
                    constructeur: vehiculesinfos[userVehiculeId].groupe ?? "0",
                    api_email: vehiculesinfos[userVehiculeId].api_email ?? "",
                    api_password: vehiculesinfos[userVehiculeId].api_password ?? "0",
                    vin: vehiculesinfos[userVehiculeId].vin ?? "0",
                    marque: vehiculesinfos[userVehiculeId].marque ?? "0",
                    modele: vehiculesinfos[userVehiculeId].model ?? "0",
                  )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: color_UnselectItem,
              selectedItemColor: color_selectItem,
              currentIndex: _currentIndex,
              backgroundColor: color_background2,
              items: (vehiculesinfos[userVehiculeId].econnect == 1)
                  ? _bottomNavigationBarItems_with_econnect
                  : _bottomNavigationBarItems_no_econnect,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                });
              },
            ),
          );
        } else {
          return UpDownLoader(
            size: 12,
            firstColor: Colors.teal,
            secondColor: Colors.black,
            //  duration: Duration(milliseconds: 600),
          );
        }
      });

  DrawerHeader drawerHeader() {
    return DrawerHeader(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.car_rental, color: color_background, size: 48),
          Text("My Car Application")
        ],
      )),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        //   itemExtent: 30.0,
        shrinkWrap: true,
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(
                child: Text(
                  'My Car Application',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Mes papiers'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => mespapiers()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Mes adresses'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const mesadresses()));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Fourrière'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => fourriere(
                          immatriculation:
                              vehiculesinfos[0].plaque.toString())));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Accident'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => accident()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Panne'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => pannes()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Objets sur la route'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SpeedCameraAlert()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Défribillateurs'), // Accident
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => defribillateur()));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Comparateur Assurance'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sensors()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Centre de controle technique'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApiFrenchControleTechnique()));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Mes points'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const mespoints()));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: const Text('Badge Parking Clonage'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => contraventions()));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: const Text('Partager'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ParkingInformations()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const screenparam()));
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  // request permissions
  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.sensors,
        Permission.location,
        Permission.bluetooth,
      ].request();

      print(statuses[Permission.camera]);
      print(statuses[Permission.sensors]);
      print(statuses[Permission.location]);
      print(statuses[Permission.bluetooth]);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.activityRecognition,
        Permission.location,
        Permission.bluetooth,
      ].request();

      print(statuses[Permission.camera]);
      print(statuses[Permission.activityRecognition]);
      print(statuses[Permission.location]);
      print(statuses[Permission.bluetooth]);
    }
  }
}
