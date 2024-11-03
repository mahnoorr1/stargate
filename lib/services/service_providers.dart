import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:stargate/utils/app_enums.dart';

Future<List<User>> getAllServiceUsers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };

  try {
    var request = http.Request('GET', Uri.parse('${server}user/'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      try {
        final decodedData = jsonDecode(jsonString);
        final users = (decodedData['data'] as List<dynamic>)
            .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
            .toList();
        return users;
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('Failed to get users: ${response.statusCode}');
    }
  } catch (e) {
    return [];
  }
}

Future<List<User>> filterServiceUsers({
  String? country,
  String? city,
  String? experience,
  String? profession,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };
  Map<String, String> queryParams = {};

  if (profession != null &&
      profession.isNotEmpty &&
      profession != UserType.all.name) {
    queryParams['professions'] = profession;
  }
  if (country != null && country.isNotEmpty) {
    queryParams['country'] = country;
  }
  if (city != null && city.isNotEmpty) {
    queryParams['city'] = city;
  }
  if (experience != null && experience.isNotEmpty) {
    queryParams['experience'] = experience;
  }

  try {
    String baseUrl = "${server}user/filter";
    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      try {
        final users = (data['data'] as List<dynamic>)
            .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
            .toList();

        return users;
      } catch (e) {
        return [];
      }
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to get users: ${response.statusCode}');
    }
  } catch (e) {
    return [];
  }
}
