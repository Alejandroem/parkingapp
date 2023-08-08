import 'package:parking/domain/models/lat_lng.dart';

class LiveLocation {
  LatitudeLongitude location;
  double speed;

  LiveLocation({
    required this.location,
    required this.speed,
  });
}
