import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:location/location.dart';

/*
void main() => runApp(MyApp3());

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeedCameraAlert(),
    );
  }
}
*/

class SpeedCameraAlert extends StatefulWidget {
  @override
  _SpeedCameraAlertState createState() => _SpeedCameraAlertState();
}

class _SpeedCameraAlertState extends State<SpeedCameraAlert> {
  CancellationToken? cancellationToken;

  int isLoaded = 0;

  bool VehiculeIsInsideRadarZone = false;

  String? msg;

  Timer? timer;

  // late List<Radars> listRadars;

  List<List<double>> listRadars = [];

  List<List<double>> listeDeRadars = [];

  LocationData? locationData;
  LocationData? locationData0;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Position? _InitialUserLocation;

  double InitialLatitude = 0.00;
  double InitialLongitude = 0.00;

  Position? _userLocation;
  Position? _currentPosition;


  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    SpeedCamerasRequest();
    _initLocation();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => isVehicleApproaching());
  }

  Future<void> _initLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          //   desiredAccuracy: LocationAccuracy.high,
          );
      setState(() {
       // _userLocation = position;
        InitialLatitude = position!.latitude;
        InitialLongitude = position!.longitude;
      });
    } catch (e) {
      print("Erreur lors de la récupération de la localisation initiale : $e");
    }
  }

  Future<void> _updateLocation() async {
    Geolocator.getPositionStream(
            //  desiredAccuracy: LocationAccuracy.high,
            //  distanceFilter: 10, // Mettez à jour la localisation toutes les 10 mètres
            )
        .listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Proximity Alert"),
          content: Text("You are within 500 meters of a target location!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List?> SpeedCamerasRequest() async {
    /// step 0 : get user position

    Position CurrentPosition = await Geolocator.getCurrentPosition();

    /// step 1 : get data from the server

    print(
        '-------------------------------/ SpeedCamera Request 1--------------------------------------');

    // URL :
    // https://mycarapp.fr:8443/mca/camera/france?48.8739087,2.3174906,20

    // resultat:
    // {"camera":"[[48.85958, 2.32214, 48.85725, 2.32425], [48.86064, 2.33111, 48.85969, 2.33522], [48.86964, 2.33622, 48.86886, 2.34028], [48.86225, 2.3415, 48.85958, 2.34014], [48.89947, 2.30933, 48.90192, 2.30722], [48.90044, 2.32192, 48.89094, 2.29942], [48.87964, 2.34944, 48.87856, 2.34583], [48.85736, 2.34667, 48.85611, 2.35047], [48.87786, 2.35158, 48.87892, 2.35561], [48.86642, 2.35172, 48.86558, 2.35561], [48.87789, 2.28058, 48.89081, 2.29961], [48.90097, 2.34792, 48.90044, 2.3755], [48.87958, 2.27678, 48.88778, 2.25133], [48.88431, 2.35883, 48.88431, 2.36317], [48.83639, 2.29467, 48.83808, 2.29803], [48.87578, 2.27342, 48.87444, 2.26969], [48.90156, 2.27931, 48.91206, 2.30156], [48.87431, 2.26936, 48.87297, 2.26564], [48.90136, 2.27769, 48.90028, 2.27397], [48.87411, 2.26886, 48.87544, 2.27258]]"}

    String _urlPrefix = "https://www.mycarapp.fr:8443";
    String _urlPath = "/mca/camera/france";
    String? _lattitude = CurrentPosition.latitude.toString();
    String? _longitude = CurrentPosition.longitude.toString();
    String _km = "20";

    String _url = "$_urlPrefix$_urlPath?$_lattitude,$_longitude,$_km";

    final Uri url = Uri.parse(_url);

    print('-----_url : $_url');

    setState(() {
      msg = 'begin request';
    });

    cancellationToken = CancellationToken();

    try {
      await HttpClientHelper.get(
        url,
        cancelToken: cancellationToken,
        timeRetry: const Duration(milliseconds: 100),
        retries: 3,
        timeLimit: const Duration(seconds: 200),
      ).then((Response? response) {
        // setState(() {
        print('*****************************************');
        print('response if ok from the server');
        print(response!.body);
        print('*****************************************');

        /// Step 2 : convert to a List

        //     String jsonStr = '{"camera":"[[48.85958, 2.32214, 48.85725, 2.32425], [48.86064, 2.33111, 48.85969, 2.33522], [48.86964, 2.33622, 48.86886, 2.34028], [48.86225, 2.3415, 48.85958, 2.34014], [48.89947, 2.30933, 48.90192, 2.30722], [48.90044, 2.32192, 48.89094, 2.29942], [48.87964, 2.34944, 48.87856, 2.34583], [48.85736, 2.34667, 48.85611, 2.35047], [48.87786, 2.35158, 48.87892, 2.35561], [48.86642, 2.35172, 48.86558, 2.35561], [48.87789, 2.28058, 48.89081, 2.29961], [48.90097, 2.34792, 48.90044, 2.3755], [48.87958, 2.27678, 48.88778, 2.25133], [48.88431, 2.35883, 48.88431, 2.36317], [48.83639, 2.29467, 48.83808, 2.29803], [48.87578, 2.27342, 48.87444, 2.26969], [48.90156, 2.27931, 48.91206, 2.30156], [48.87431, 2.26936, 48.87297, 2.26564], [48.90136, 2.27769, 48.90028, 2.27397], [48.87411, 2.26886, 48.87544, 2.27258]]"}';

        Map<String, dynamic> jsonData = jsonDecode(response!.body);

        // Accédez à la valeur de la clé 'camera' dans le JSON
        String cameraData = jsonData['camera'];

        // Supprimez les caractères `[` et `]` pour obtenir une liste de listes
        cameraData = cameraData.replaceAll('[', '').replaceAll(']', '');

        // Divisez les valeurs en une liste de chaînes
        List<String> lignes = cameraData.split(', ');

        for (int i = 0; i < lignes.length; i += 4) {
          double lat1 = double.parse(lignes[i]);
          double lon1 = double.parse(lignes[i + 1]);
          double lat2 = double.parse(lignes[i + 2]);
          double lon2 = double.parse(lignes[i + 3]);
          listeDeRadars.add([lat1, lon1, lat2, lon2]);
        }

        // Affichez la liste de listes résultante
        print("**************************************listRadars");
        print(listeDeRadars);

        setState(() {
          isLoaded = 2;
        });

        print("isLoaded = $isLoaded");

        return listRadars;
      });
    } on TimeoutException catch (_) {
      setState(() {
        msg = 'TimeoutException';
        setState(() {
          isLoaded = 1;
        });
        return null;
      });
    } on OperationCanceledError catch (_) {
      setState(() {
        msg = 'cancel';
        setState(() {
          isLoaded = 1;
        });
        return null;
      });
    } catch (e) {
      setState(() {
        msg = '$e';
        setState(() {
          isLoaded = 1;
        });
        return null;
      });
    }
  }

  Future<void> isVehicleApproaching() async {
    double startLatitude = 0.00;
    double startLongitude = 0.00;
    double endLatitude = 0.00;
    double endLongitude = 0.00;
    double distance_initial = 0.00;
    double distance_startZone = 0.00;
    double distance_endZone = 0.00;
    double distance_endZone2 = 0.00;
    double beforeLatitude = 0.00;
    double beforeLongitude = 0.00;
    int ref = 0;

    bool VehiculeIsInApproach = false;
    bool AlertSpeedCamera = false;

    // verify is the distance from initial location is or not over than 20 000 meters and if it is over we ask to get new list of speed cameras

    Position? CurrentPosition = await Geolocator.getLastKnownPosition();

    Position? LastPosition = await Geolocator.getLastKnownPosition();

      distance_initial = Geolocator.distanceBetween(
      InitialLatitude,
      InitialLongitude,
      CurrentPosition!.latitude,
      CurrentPosition!.longitude,
    );

    if (distance_initial > 20000) {
      // distance from initial location when the user start is over than 20 000 meters
      // we ask to get new list of speed cameras
      SpeedCamerasRequest();
      // we save the position as new Initial Position
      InitialLatitude = CurrentPosition!.latitude;
      InitialLongitude = CurrentPosition!.longitude;
    }

    if (!VehiculeIsInsideRadarZone) {

      for (var point in listRadars) {


        ref = point as int;
        //   startLatitude  = listRadars[ref][0];
        //   startLongitude = listRadars[ref][1];

        double distance_startZone = Geolocator.distanceBetween(
          CurrentPosition!.latitude,
          CurrentPosition!.longitude,
          listRadars[ref][0],
          listRadars[ref][1],
        );

        print("-----------Distance du radar = $distance_startZone");

        if (distance_startZone <= 50) {

          endLatitude = listRadars[ref][2];
          endLongitude = listRadars[ref][3];
          distance_endZone = Geolocator.distanceBetween(
            CurrentPosition!.latitude,
            CurrentPosition!.longitude,
            endLatitude,
            endLongitude,
          );
          setState(() {
            VehiculeIsInsideRadarZone = true;
          });

          break;
        }


      }

    } else {  //  VehiculeIsInsideRadar = true ==> The vehicule is between start point and end point

      if(AlertSpeedCamera) {
        // show alert
        _showAlert();
      }

      distance_endZone = Geolocator.distanceBetween(
        CurrentPosition!.latitude,
        CurrentPosition!.longitude,
        endLatitude,
        endLongitude,
      );

      if (distance_endZone <= 50) {
        setState(() {
          VehiculeIsInsideRadarZone = false;
          AlertSpeedCamera = false;
        });
      }


      }

  }

  /*
  // code to calculate distance between to points without using Geolocator
  //
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    double dLat = (lat2 - lat1).toDouble();
    double dLon = (lon2 - lon1).toDouble();
    double a = (dLat / 2) * (dLat / 2) + (dLon / 2) * (dLon / 2) * (lat1).cos() * (lat2).cos();
    double c = 2 * (a).atan2((a).sqrt() * (1 - a).sqrt());
    return earthRadius * c;
  }
  */

  @override
  Widget build(BuildContext context) {
    isVehicleApproaching();
    return Scaffold(
      appBar: AppBar(
        title: Text("Radars Alert"),
      ),
      body: Center(
        child: Text(
                "Ma Latitude: ${InitialLatitude!}\n"
                "Ma Longitude: ${InitialLongitude!}",
              ),
      ),
    );
  }
}
