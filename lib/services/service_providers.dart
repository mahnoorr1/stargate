import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/models/user.dart';
import 'package:http/http.dart' as http;

Future<List<User>> getAllServiceUsers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    // 'Cookie': "accessToken=${token!}",
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
        print(decodedData);

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
    print(e.toString());
    return [];
  }
}

Future<List<User>> filterServiceUsers({
  String? country,
  String? city,
  String? experience,
  String? profession,
}) async {
  print("entered");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    // 'Cookie': "accessToken=${token!}",
    'Authorization': token!,
  };
  print(token);
  Map<String, String> queryParams = {};

  if (profession != null && profession.isNotEmpty) {
    queryParams['profession'] = profession;
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

    final response = await http.get(uri);
    print("sent");
    if (response.statusCode == 200) {
      print(200);
      var data = json.decode(response.body);
      print(data);
      try {
        final users = (data['data'] as List<dynamic>)
            .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
            .toList();
        print(users);
        return users;
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('Failed to get users: ${response.statusCode}');
    }
  } catch (e) {
    print("errorrr  $e");
    return [];
  }
}
