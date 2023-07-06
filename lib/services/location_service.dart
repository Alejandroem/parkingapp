
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;


class LocationService {


  //Get Position
  Future<LocationData?> getPosition() async {
    try {
      Location location = Location();
      return location.getLocation();
    } on PlatformException catch (error) {
      print("Nous avons une erreur pour récupérer la position: \n ${error.message}");
      return null;
    }
  }

  //Convertir Position en ville
  Future<GeoPosition?> getCity() async {
    final position = await getPosition();
    if (position == null) return null;
    final lat = position.latitude ?? 0.0;
    final lon = position.longitude ?? 0.0;
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat, lon);
    final firstChoice = placemarks.first;
    final GeoPosition geoPosition = GeoPosition(
        city: firstChoice.locality ?? "",
        lat: lat,
        lon: lon
    );
    return geoPosition;
  }

  //Convertir ville en position
  Future<GeoPosition?> getCoordsFromCity(String city) async {
    final placemarks = await geocoding.locationFromAddress(city);
    if (placemarks.isEmpty) return null;
    final bestChoice = placemarks.first;
    return GeoPosition(
        city: city,
        lat: bestChoice.latitude,
        lon: bestChoice.longitude
    );
  }


}


class GeoPosition {
  String city;
  double lat;
  double lon;

  GeoPosition({
    required this.city,
    required this.lat,
    required this.lon
  });
}
