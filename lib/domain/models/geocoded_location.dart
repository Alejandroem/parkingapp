import 'package:parking/domain/models/lat_lng.dart';

class GeocodedLocation {
  String placeName;
  LatitudeLongitude uncodedLocation;
  LatitudeLongitude encodedLocation;

  GeocodedLocation(
    this.placeName,
    this.uncodedLocation,
    this.encodedLocation,
  );
}
