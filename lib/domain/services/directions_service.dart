import 'package:parking/domain/models/lat_lng.dart';

abstract class DirectionsService {
  Future<List<LatitudeLongitude>> getDirections(
      {required LatitudeLongitude origin,
      required LatitudeLongitude destination});
}
