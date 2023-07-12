
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:json_helpers/json_helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils.dart';
import '../widget/widgets.dart';
import '../api_defribilateur/api_defribilateur_response.dart';
import '../services/location_service.dart';
//import 'package:http_requests/http_requests.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;


class ApiDefribilateurCall  {


  String username = 'pbellavoine';
  String password = 'MyCar75008+2023!';
  String urlPrefix = 'https://api-geodae.sante.gouv.fr/api/login';
  String? token;

  GeoPosition? positionToCall;

  http.Response? response;


  // Future<ApiDefribilateur_response> DefribilateursList() async {
  //
  //   ///* request geoposition
  //   print ('******************************REQUEST getGeoPosition********************************');
  //   var _position = await getGeoPosition();
  //   print (_position);
  //
  //   ///* request token
  //   print ('******************************REQUEST POST ==> Token********************************');
  //   var _token = await register();
  //   print(_token);
  //
  //
  //   ///* request confirmation token valid
  //   print ('******************************REQUEST TOKEN CONFIRMATION*******************************');
  //   var _token_confirmation = await register_confirmation();
  //   print(_token_confirmation);
  //
  //
  //   ///* request List of defribilateurs arround the position
  //   ///
  //   print ('**********************REQUEST GET List of defribilateurs****************************');
  //   var  _listDefribilateurs = await get_defribilateurs_list();
  //
  //   ///* map and return
  //   ///
  //   Map<String, dynamic> map = json.decode(_listDefribilateurs!);
  //
  //   print('>>> ${ApiDefribilateur_response.fromJson(map)}');
  //   return ApiDefribilateur_response.fromJson(map);
  //
  // }


  Future<List<dynamic>> DefribilateursList() async {
    /// Request geoposition
    print('******************************REQUEST getGeoPosition********************************');
    var _position = await getGeoPosition();
    print(_position);

    /// Request token
    print('******************************REQUEST POST ==> Token********************************');
    var _token = await register();
    print(_token);

    /// Request confirmation token validity
    print('******************************REQUEST TOKEN CONFIRMATION*******************************');
    var _token_confirmation = await register_confirmation();
    print(_token_confirmation);

    /// Request list of defibrillators around the position
    print('**********************REQUEST GET List of defibrillateurs****************************');
    var _listDefribilateurs = await get_defribilateurs_list();

    /// Map and return
    List<dynamic> map = json.decode(_listDefribilateurs!);
    return map;
  //  print('>>> ${map}');
  //  return ApiDefribilateur_response.fromJson(map);
  }


  //get position
  getGeoPosition() async {
    // find position of the user
    final loc = await LocationService().getCity();
    if (loc != null) {
      positionToCall = loc;
    }
  }



  Future<String?> register() async {

    /*
  Curl :
  curl -X POST "https://api-geodae.sante.gouv.fr/api/login" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"username\": \"pbellavoine\", \"password\": \"MyCar75008+2023!\"}"

  Request URL :
  https://api-geodae.sante.gouv.fr/api/login
   */


    try {
      response =
      await http.post(
        Uri.parse(urlPrefix),
        headers: <String, String>{
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'username': username,
            'password': password
          },
        ),
      );
    } catch (e) {
      log(e.toString());
    };
    print('Response status: ${response?.statusCode}');
    print('Response body: ${response?.body}');
    if (response?.statusCode == 201) {
      return(response!.body);
    } else {
      return("");
    }

    /*
      Server response
      201
      Response body
      Download
      {
      "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODg4MTE4ODIsImV4cCI6MTY4ODgxMzY4MiwiaWQiOjQ0MzMxfQ.0Kum0Vo6LUzrVirzOT6R01FgnqLTxrxql3gcAiLR5yY"
      }
      Response headers
      cache-control: max-age=0, must-revalidate, private
      connection: Keep-Alive
      content-length: 155
      content-type: application/json
      date: Sat, 08 Jul 2023 10:24:42 GMT
      expires: Sat, 08 Jul 2023 10:24:42 GMT
      keep-alive: timeout=5, max=300
      pragma: no-cache
      server: integra
      strict-transport-security: max-age=31536000; includeSubDomains
     */

  }

  Future<String?> register_confirmation() async {

    /*
  Curl :
  curl -X POST "https://api-geodae.sante.gouv.fr/api/login" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"username\": \"pbellavoine\", \"password\": \"MyCar75008+2023!\"}"

  Request URL :
  https://api-geodae.sante.gouv.fr/api/login
   */


    // String? _token   = response!.body;

    print('******************* jsondecode response.body');
    print(response!.body);
    print ('********************************************');
    final _token = TokenAPI.fromJson(json.decode(response!.body));
    token = _token.token.toString();

    print("TOKEN IS = ---" + token! + "---");

    try {
      response =
      await http.post(
        Uri.parse(urlPrefix),
        headers: <String, String>{
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {
            'username': username,
            'password': password
          },
        ),
      );
    } catch (e) {
      log(e.toString());
    };
    print('Response status: ${response?.statusCode}');
    print('Response body: ${response?.body}');
    if (response?.statusCode == 201) {
      return(response!.body);
    } else {
      return("");
    }

    /*

      201
      Response body
      Download
      {
      "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODg4MTE4ODIsImV4cCI6MTY4ODgxMzY4MiwiaWQiOjQ0MzMxfQ.0Kum0Vo6LUzrVirzOT6R01FgnqLTxrxql3gcAiLR5yY"
      }
      Response headers
      cache-control: max-age=0, must-revalidate, private
      connection: Keep-Alive
      content-length: 155
      content-type: application/json
      date: Sat, 08 Jul 2023 10:24:42 GMT
      expires: Sat, 08 Jul 2023 10:24:42 GMT
      keep-alive: timeout=5, max=300
      pragma: no-cache
      server: integra
      strict-transport-security: max-age=31536000; includeSubDomains
     */

  }

  Future<String?> get_defribilateurs_list() async {

    /*
    curl -X GET "https://api-geodae.sante.gouv.fr/api/dae?offset=0&limit=20&sort_by=com_nom%3Aasc&_where=%3F_where%3Deq(com_nom%2CParis)" -H "accept: application/json" -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODg5NzExMDUsImV4cCI6MTY4ODk3MjkwNSwiaWQiOjQ0MzMxfQ.pwMAdXdvdMpWs_QeYbGsDwhe8tBWjMFNKjSeMpRN6yo"
     Request URL :
     https://api-geodae.sante.gouv.fr/api/dae?limit=20&sort_by=latCoor1&_where=%3F_where%3Deq(com_nom%2CParis)
      */

    // String urlPrefix = 'https://api-geodae.sante.gouv.fr/api/dae?offset=0&limit=20&sort_by=com_nom%3Aasc&_where=%3F_where%3Dand(eq(com_nom%2CParis)%2Ceq(acc%2CInt%C3%A9rieur))';

    String urlPrefix = "https://api-geodae.sante.gouv.fr/api/dae";
    String _offset   = "offset=0";
    String _limit    = "limit=20";
    String _sort_by  = "sort_by=com_nom:asc";
    String _where    = "?_where=(eq(com_nom,Paris))";

    String prepareQuery() {
      return "$urlPrefix?$_offset&$_limit&$_sort_by&$_where";
    }

    final queryString = prepareQuery();

    print ("queryString : " + queryString);


    try {
      response =
      await http.get(
        Uri.parse(queryString),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      log(e.toString());
    };

    print('Response 2 status : ${response?.statusCode}');
    print('Response  2 jsonDecode body: ${jsonDecode(response!.body)}');

    if (response?.statusCode == 200) {
      return(response?.body);
    } else {
      return("");
    }
  }

}

class TokenAPI {
  String? token;

  TokenAPI(
      {this.token});

  TokenAPI.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}


