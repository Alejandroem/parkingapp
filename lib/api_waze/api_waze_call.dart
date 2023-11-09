
import 'dart:async';
import 'dart:convert';
import '../services/location_service.dart';
import 'package:http_requests/http_requests.dart';
import 'api_waze_response.dart';

class WazeCall {

  String url0 = "https://waze.p.rapidapi.com/alerts-and-jams?bottom_left=40.66615391742187%2C-74.13732147216798&top_right=40.772787404902594%2C-73.76818084716798&max_alerts=20&max_jams=20";
  var url;
  String base_url = "https://waze.p.rapidapi.com/alerts-and-jams";
  String bottom_left_lat = "43.787057";
  String bottom_left_lon = "4.810358";
  String top_right_lat = "48.869114";
  String top_right_lon = "2.325324";
  int max_alerts = 20;
  int max_jams = 20;



  Future<Object> WazeResponseApi(GeoPosition position) async {

    Map<String, String> header =  {
      "X-RapidAPI-Key" : "2f5ce514d4mshff68d6d579a8f5cp137864jsna51656dda727",
      "X-RapidAPI-Host": "waze.p.rapidapi.com"
    };

    var url_complete = "https://waze.p.rapidapi.com/alerts-and-jams?bottom_left=40.66615391742187%2C-74.13732147216798&top_right=40.772787404902594%2C-73.76818084716798&max_alerts=20&max_jams=20";

  //  final url = Uri.parse(url_complete);

  //  final url_create = Uri.parse("$base_url?bottom_left=$bottom_left_lat%2C-$bottom_left_lon&top_right=$top_right_lat%2C-$top_right_lon&max_alerts=$max_alerts&max_jams=$max_jams");
    final url_create = "$base_url?bottom_left=$bottom_left_lat%2C-$bottom_left_lon&top_right=$top_right_lat%2C-$top_right_lon&max_alerts=$max_alerts&max_jams=$max_jams";

    Response response = await HttpRequests.get(url_create, headers: header);




    print('====================================================================================');
    print('===========================================URL======================================');
    print(url_create);
    print('=====================================================================================');
    print(response.statusCode);
    print('=====================================================================================');
    print('=====================================================================================');
    print('=====================================================================================');

    // Code 200 = la requete a aboutie positivement et la reponse retournée

    if(response.statusCode == 200) {

      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');
      print('-----------------------------CODE 200-------------------------------------------');
      print(response.content);
      print('--------------------------------------------------------------------------------');
      print('--------------------------------------------------------------------------------');

      Map<String, dynamic> map = json.decode(response.content);

      print('****************************************************************');
      print('****************************************************************');
      print('****************************************************************');
      print('****************************************************************');
      print('***************************MAP**********************************');
      print(map);
      print('***************************MAP END******************************');
      print('****************************************************************');
      print('****************************************************************');
      print('****************************************************************');
      print('****************************************************************');

      return ApiWaze_response.fromJson(map);
    }
    else
      { return ApiWaze_response;}

  }

}