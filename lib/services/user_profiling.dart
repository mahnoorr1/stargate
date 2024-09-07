import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/models/profile.dart';

Future<String?> loginUser(String email, String pass) async {
  var headers = {
    'Content-Type': 'application/json',
  };
  var request = http.Request('POST', Uri.parse('${server}user/login'));

  try {
    request.body = json.encode({"email": email, "password": pass});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      String? token = responseData['data']['accessToken'] as String?;
      storeAccessToken(token!);
      return 'token';
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      return errorMessage;
    }
  } catch (e) {
    return e.toString();
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
  var request = http.Request('POST', Uri.parse('${server}user/register'));

  try {
    request.body = json.encode({
      "name": name,
      "email": email,
      "password": pass,
      "profession": profession.toLowerCase(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      String? token = responseData['data']['accessToken'] as String?;
      storeAccessToken(token!);
      return 'token';
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      return errorMessage;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<User?> myProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': "accessToken=${token!}",
  };
  var request = http.Request('GET', Uri.parse('${server}user/my-profile'));

  try {
    request.body = '';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      final user = User.fromJson(responseData['message']);
      return user;
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      if (kDebugMode) {
        print(errorMessage);
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return null;
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
