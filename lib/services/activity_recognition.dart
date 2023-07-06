


class ActivityRecognitionService {

  final int? ActivityType;

  ActivityRecognitionService({this.ActivityType});


///* -------------------------------------------------------------------------
///
/// Gestion du detecteur d'activité
///
/// --------------------------------------------------------------------------
/*

  switch (ActivityType) {
    case ActivityType.IN_VEHICLE:
      activityType = 'En voiture';
      CarState = 1;
      break;
    case ActivityType.ON_BICYCLE:
      activityType = 'À vélo';
      CarState = 1;
      break;
    case ActivityType.STILL:
      activityType = 'Immobile';
      (CarState == 1) ? CarState = 1 : CarState = 0;
      break;
    case ActivityType.WALKING:
      activityType = 'Marche';
      (CarState == 1) ? CarState = 2 : CarState = 0;
      break;
    case ActivityType.RUNNING:
      activityType = 'Course';
      (CarState == 1) ? CarState = 2 : CarState = 0;
      break;
    case ActivityType.UNKNOWN:
      activityType = 'Inconnue';
      (CarState == 1) ? CarState = 1 : CarState = 0;
      break;
  }

  switch (CarState) {
    case 0:

      break;

    case 1:

    /// declencher suivi et affichage de la vitesse du véhicule
    /// déclencher  poly_geofence_service si le vehicule est en stationnement residentiel
    /// pour controler si l'utilisateur est ou n'est pas dans sa zone de stationnement résidentiel
    ///
    // actualActivity == previousActivity;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const screen2_road()),
      );
      break;

    case 2:

    /// le véhicule vient d'être stationné
    /// on prend, on mémorise et on affiche l'emplacement
    ///
      final loc = await LocationService().getCity();
      if (loc != null) {
        setState(
              () async {
            CarParkingGeolocalisation = loc;
            CarParkingDateTime = DateTime.now();
            List<geocoding.Placemark> placemarks =
            await geocoding.placemarkFromCoordinates(
                CarParkingGeolocalisation?.lat,
                CarParkingGeolocalisation?.lon);
            CarParkingAdresse = placemarks.reversed.last.street.toString() +
                " - " +
                placemarks.reversed.last.postalCode.toString() +
                " -" +
                placemarks.reversed.last.country.toString() +
                " -";
          },
        );
      }
      CarState = 0;



      break;
  }

  setState(() {});

  */
}







