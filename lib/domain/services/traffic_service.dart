import 'package:parking/domain/models/lat_lng.dart';

abstract class TrafficService {
  Future<List<LatitudeLongitude>> getTraffic();
}
