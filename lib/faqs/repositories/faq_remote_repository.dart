import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../config/constants.dart';
import '../model/faq_model.dart';

class FaqRemoteRepository {
  static Future<List<FAQ>> getFAQs({
    required String token,
  }) async {
    try {
      var headers = {
        'Authorization': token,
      };
      var request = http.Request('GET', Uri.parse('$server/user/faq'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());

        return (decodedData["data"] as List)
            .map((item) => FAQ.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        log(response.reasonPhrase.toString());
        throw Exception("Error fetching FAQs: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("get FAQs error: $e");
      throw Exception("Error fetching FAQs: $e");
    }
  }
}
