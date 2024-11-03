import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/models/profile.dart';

Future<String?> loginUser(String email, String pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
      storeUserData(
        name: responseData['data']['user']['name'],
        email: email,
        id: responseData['data']['user']['_id'],
        membership: responseData['data']['user']['membership'],
        image: responseData['data']['user']['profilePicture'],
      );
      storeAccessToken(token!);
      String? tokenn = prefs.getString('accessToken');
      // ignore: avoid_print
      print(tokenn);
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
      var responseData = jsonDecode(jsonString);
      String? token = responseData['data']['accessToken'];
      storeUserData(
        name: responseData['data']['user']['name'],
        email: email,
        id: responseData['data']['user']['_id'],
        membership: responseData['data']['user']['membership']['_id'],
      );
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
    'Authorization': token!,
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

Future<String> updateProfile({
  required String name,
  required String address,
  required String city,
  required String country,
  required List<Service> professions,
  required List<dynamic> references,
  required String websiteLink,
  String? profile,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };
  var request =
      http.MultipartRequest('PATCH', Uri.parse('${server}user/update-profile'));
  try {
    request.fields.addAll({
      "name": name,
      "address": address,
      "city": city,
      "country": country,
      "websiteLink": websiteLink,
    });
    if (profile != '' && profile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profilePicture', profile));
    }
    if (references.isNotEmpty) {
      for (int i = 0; i < references.length; i++) {
        request.files.add(
            await http.MultipartFile.fromPath('references', references[i]));
      }
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      storeUserData(
        name: responseData['data']['name'],
        email: responseData['data']['email'],
        id: responseData['data']['_id'],
        membership: responseData['data']['membership'],
      );
      String profession = await updateProfessions(professions: professions);
      return profession == 'Success' ? 'Success' : 'Error';
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

Future<String> updateProfessions({required List<Service> professions}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };
  var request =
      http.Request('PATCH', Uri.parse('${server}user/update-profile'));

  try {
    request.body = jsonEncode({
      "professions": professions.map((item) {
        if (item.details['name'].toLowerCase() == 'investor') {
          return {
            "name": item.details['name'],
            "investmentRange": {
              "min": item.details['investmentRange']['min'],
              "max": item.details['investmentRange']['max'],
            },
            "specialization": item.details['specialization'] ?? "",
            "preferredInvestmentCategories": List<String>.from(
                item.details['preferredInvestmentCategories'] ?? []),
          };
        } else {
          return {
            "name": item.details['name'],
            "specialization": item.details['specialization'] ?? "",
            "yearsOfExperience": item.details['yearsOfExperience'] ?? 0,
          };
        }
      }).toList(),
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Success';
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

void storeAccessToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', token);
}

void deleteAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', '');
}

void storeUserData({
  required String name,
  required String email,
  required String id,
  String? image,
  required String membership,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profile', image ?? '');
  prefs.setString('id', id);
  prefs.setString('name', name);
  prefs.setString('email', email);
  prefs.setString('membership', membership);
}

void deleteUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profile', '');
  prefs.setString('id', '');
  prefs.setString('name', '');
  prefs.setString('email', '');
  prefs.setString('membership', '');
}

Future<String> verifyOTP(String otp, String email) async {
  var request = http.Request('POST', Uri.parse('${server}user/verify-otp'));

  try {
    request.body = json.encode({
      "otp": otp,
      "email": email,
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return "Email verified, login to continue!";
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      print(errorData);
      return errorMessage;
    }
  } catch (e) {
    return e.toString();
  }
}
