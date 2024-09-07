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
    'Cookie': "accessToken=${token!}",
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
