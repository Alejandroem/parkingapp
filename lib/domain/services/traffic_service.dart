
import '../models/lat_lng.dart';

abstract class TrafficService {
  Future<List<LatitudeLongitude>> getTraffic();
}
