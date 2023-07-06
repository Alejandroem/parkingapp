
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../api_defribilateur/api_defribilateur_response.dart';
import '../services/location_service.dart';
//import 'package:http_requests/http_requests.dart';
import 'package:http/http.dart';

class ApiDefribilateur {


/*

  Future<void> makePutRequest() async {
    resultNotifier.value = RequestLoadInProgress();
    final url = Uri.parse('$urlPrefix/posts/1');
    final headers = {"Content-type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';
    final response = await put(url, headers: headers, body: json);
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    _handleResponse(response);
  }

   */


/*
  Future<AuthResponse> doLogin(User user) async {
    String url = apiUrl ?? AppConfig().get('apiUrl');
    url += _loginPath;
    Map<String, String> bodyReq = user.toJson();

    Response res = await post(url, headers: headers, body: bodyReq);
    //Response res = await post(url, body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> bodyRes = jsonDecode(res.body);
      AuthResponse auth = AuthResponse.fromJson(bodyRes);
      return auth;
    } else {
      throw AuthException(message: "Login fails!");
    }
  }

  Future<AuthResponse> doSignup(User user) async {
    String url = apiUrl ?? AppConfig().get('apiUrl');
    url += _registerPath;
    Map<String, String> bodyReq = user.toJson();

    Response res = await post(url, headers: headers, body: bodyReq);
    //Response res = await post(url, body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> bodyRes = jsonDecode(res.body);
      AuthResponse auth = AuthResponse.fromJson(bodyRes);
      return auth;
    } else {
      throw ("Signup fails!");
    }
  }

  Future<void> doLogout(RefreshToken token) async {
    String url = apiUrl ?? AppConfig().get('apiUrl');
    url += _logoutPath;
    Map<String, String> bodyReq = token.toJson();

    final client = Client();
    try {
      final response = await client.send(Request("DELETE", Uri.parse(url))
        ..headers.addAll(<String, String>{
          "Accept": "application/json",
          "Connection": "keep-alive",
          "Content-Type": "application/json"
        })
        ..body = json.encode(bodyReq));

      if (response.statusCode != 204) {
        throw ("Logout fails!");
      }
    } finally {
      client.close();
    }
  }

*/
/*
  Future<Object> doSignup(GeoPosition position) async {

    const urlPrefix = 'https://api-geodae.sante.gouv.fr/api/login';
    final String _loginPath = '/login';
    final String _refreshPath = '/token';
    final String _registerPath = '/signup';
    final String _logoutPath = '/logout';


    Map<String, String> headers = {
      "Accept": "application/json",
      "Connection": "keep-alive",
      "Content-type": "application/x-www-form-urlencoded",
    };

    final username = 'pbellavoine';
    final password = 'MyCar75008+2023!';
    final credentials = '$username:$password';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);

    var token;


      Map<String, String> bodyReq = user.toJson();

      Response res = await post(url, headers: headers, body: bodyReq);
      //Response res = await post(url, body: body);
/*
      if (res.statusCode == 200) {
        Map<String, dynamic> bodyRes = jsonDecode(res.body);
        AuthResponse auth = AuthResponse.fromJson(bodyRes);
        return auth;
      } else {
        throw AuthException(message: "Login fails!");
      }
    }
*/
   // var url_request = "https://api-geodae.sante.gouv.fr/api/login" -H "accept: application/json" -H "Authorization: pbellavoine" -H "Content-Type: application/json" -d "{ \"username\": \"pbellavoine\", \"password\": \"MyCar75008+2023!\"}";


    //  final url_create = Uri.parse("$base_url?bottom_left=$bottom_left_lat%2C-$bottom_left_lon&top_right=$top_right_lat%2C-$top_right_lon&max_alerts=$max_alerts&max_jams=$max_jams");

 //   Response response = await HttpRequests.post(url_base, headers: header, data: key);

    // response :
//{
//   "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODQ1NzQxNjMsImV4cCI6MTY4NDU3NTk2MywiaWQiOjQ0MzMxfQ.4fmmP9MjbYHYvWIbT_GzuR7k1SY3Ve2sOA9EAB6Rcd4"
// }
/*
    final token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODQ1NzQxNjMsImV4cCI6MTY4NDU3NTk2MywiaWQiOjQ0MzMxfQ.4fmmP9MjbYHYvWIbT_GzuR7k1SY3Ve2sOA9EAB6Rcd4";
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse(
          'https://example.com/api/your-cool-api'),
      headers: {
        'Authorization':
        'Bearer $token',
      },
    );
    */
    print('====================================================================================');
    print('===========================================URL======================================');
    //print(response.content);
    print('=====================================================================================');
   // print(response.statusCode);
    print('=====================================================================================');
    print('=====================================================================================');
    print('=====================================================================================');

    // Code 200 = la requete a aboutie positivement et la reponse retournée
/*
    if(response.statusCode == 201) {

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


 */
      return ApiDefribilateur_response.fromJson(map);
    }
    else
    { return ApiDefribilateur_response;}


  }
*/
}