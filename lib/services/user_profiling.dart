import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';

Future<String?> loginUser(String email, String pass) async {
  var headers = {
    'Content-Type': 'application/json',
  };
  var request = http.Request('POST', Uri.parse('${server}api/v1/user/login'));

  try {
    request.body = json.encode({"email": email, "password": pass});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      String? token = responseData['data']['accessToken'] as String?;
      storeAccessToken(token!);
      return token;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String?> registerUser(
  String name,
  String email,
  String pass,
  String profession,
) async {
  var headers = {
    'Content-Type': 'application/json',
  };
  var request =
      http.Request('POST', Uri.parse('${server}api/v1/user/register'));

  try {
    request.body = json.encode({
      "name": name,
      "email": email,
      "password": pass,
      "professions": [profession],
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      String? token = responseData['data']['accessToken'] as String?;
      storeAccessToken(token!);
      return 'token';
    }
    return 'Login Failed';
  } catch (e) {
    return e.toString();
  }
}

void storeAccessToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', token);
}

void deleteAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', '');
}
