import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map> sendDataToRegister(Map body) async {
    final response = await http.post(
        'https://clinic.cloudmed.ir/API7_v2/public/api/user/register',
        body: body);

    var responseBody = json.decode(response.body);
    return responseBody;
  }

  Future<Map> sendDataToLogin(Map body) async {
    final response = await http.post(
        'https://clinic.cloudmed.ir/API7_v2/public/api/user/login',
        body: body);

    var responseBody = json.decode(response.body);
    return responseBody;
  }

  Future<Map> sendDataToLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('token');
    final response = await http.get(
      'https://clinic.cloudmed.ir/API7_v2/public/api/user/logout',
      headers: {'Authorization': 'Bearer $apiToken'},
    );

    var responseBody = json.decode(response.body);
    return responseBody;
  }

  Future<Map> showAllPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('token');
    final response = await http.get(
      'https://clinic.cloudmed.ir/API7_v2/public/api/post',
      headers: {'Authorization': 'Bearer $apiToken'},
    );

    var responseBody = json.decode(response.body);
    return responseBody;
  }

  Future<Map> likeOrUnlike(Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('token');
    final response = await http.post(
      'https://clinic.cloudmed.ir/API7_v2/public/api/post/like',
      headers: {'Authorization': 'Bearer $apiToken'},
      body: body,
    );

    var responseBody = json.decode(response.body);
    return responseBody;
  }
}
