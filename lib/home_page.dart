import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycar/services/webview3.dart';
import 'package:provider/provider.dart';

import '../Providers/screenIndexProvider.dart';
import '../screen1.dart';
import '../screen2.dart';
import '../screen3_my_vehicule.dart';
import '../screen5_carburant.dart';
import '../screen4.dart';
import '../drawerscreens/parameters.dart';
import '../drawerscreens/fourrieres.dart';
import '../drawerscreens/accident.dart';
import '../drawerscreens/mesadresses.dart';
import '../drawerscreens/mespapiers.dart';
import '../drawerscreens/defribilateur.dart';
import '../api_controle_technique/api_FrenchControleTechnique_home.dart';
import '../drawerscreens/dev_en_cours.dart';
import '../constants.dart';
import '../databases/DatabaseClient.dart';
import '../databases/vehicules.dart';
import '../mespoints/mespoints.dart';
import '../drawerscreens/pannes.dart';
import '../mespoints/mespoints_webview.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String _appBarTitle;

  var previousActivity;
  var actualActivity;
  var currentActivity;
  var activityType;
  var CarParkingGeolocalisation;
  var CarParkingAdresse;
  var CarParkingDateTime;
  var CarState = 0;
  var CarSpeed = 0.00;

  // recupération des informations sur le véhicule
  var items = <Vehicules>[];
  Future<bool> getVehiculesInfo() async {
    final fromDb = await DatabaseClient().VehiculeInfo(idKey: 1);
    if (fromDb != null) {
      setState(() {
        items = fromDb;
        });
      return true;
    } else {
      return false;
    }
  }


  // titres des 5 écrans principaux
  final List<String> titleList = [
    "MyCar",
    "Check Control",
    'Mon véhicule',
    'Auto News',
    'Carburants'
  ];

  // écran de base
  int _currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  final _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.add_road, color: color_icone),
      label: 'En route',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.check, color: color_icone),
      label: 'Check',
      backgroundColor: color_texte1,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.drive_eta, color: color_icone),
      label: 'Mon véhicule',
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
    )
  ];

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: getVehiculesInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final _screenindexprovider =
              Provider.of<screenIndexProvider>(context);
          int currentScreenIndex = _screenindexprovider.fetchCurrentScreenIndex;
          return Scaffold(

            appBar: AppBar(
              title: Text(titleList[_currentIndex]),
              backgroundColor: color_background2,
              centerTitle: true,
              elevation: 7.5,
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
                screen1(
                    lat: items?[0].last_lattitude ?? 48.873821,
                    lon: items?[0].last_longitude ?? 2.315757,
                    isInZone: items?[0].residentiel_in ?? 0,
                    residential_zone: items?[0].residentiel_zone ?? "",
                    CurrentActivity: 0,
                    LastDateTimeParking: items?[0].residentiel_datetime ?? "",
                    LastAdresse: items?[0].last_adresse ?? ""
                    ),
                screen2(
                    lat: items?[0].last_lattitude ?? 48.873821,
                    lon: items?[0].last_longitude ?? 2.315757,
                    isInZone: items?[0].residentiel_in ?? 0,
                    CurrentActivity: 0,
                    ),
                screen3_my_vehicule(),
                screen4(),
                screen5_carburant()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: color_UnselectItem,
              selectedItemColor: color_selectItem,
              currentIndex: _currentIndex,
              backgroundColor: color_theme,
              items: _bottomNavigationBarItems,
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
        }
        else {
          return CircularProgressIndicator();
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => fourrieres()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => accident()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('Panne'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => pannes()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.train,
              ),
              title: const Text('Défribillateurs'), // Accident
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => defribilateur()));
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
                Navigator.push(context,
                    //  MaterialPageRoute(builder: (context) => DevEnCours()));
                    MaterialPageRoute(builder: (context) => DevEnCours()));
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
                    MaterialPageRoute(builder: (context) => const webview3()));
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
}
