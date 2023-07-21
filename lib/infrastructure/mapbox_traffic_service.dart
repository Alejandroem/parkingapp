import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:parking/domain/services/traffic_service.dart';

import '../constants.dart';
import '../domain/models/lat_lng.dart';

class MapBoxTrafficService extends TrafficService {
  @override
  Future<List<LatitudeLongitude>> getTraffic() async {
    try {
      final dio = Dio();

      final response = await dio.get(
        'https://api.mapbox.com/traffic/v1/incidents?access_token=${AppConstants.mapBoxAccessToken}',
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) =>
                LatitudeLongitude(e['lat'] as double, e['lng'] as double))
            .toList();
      }
    } catch (e) {
      log('Error fetching traffic data: $e');
    }
    return [];
  }
}
