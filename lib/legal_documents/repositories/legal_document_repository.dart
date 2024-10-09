import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stargate/config/constants.dart';

import '../model/legal_document_model.dart';

class LegalDocumentRepository {
  static Future<LegalDocument> getLegalDocument({
    required String token,
    required String type,
  }) async {
    try {
      var headers = {
        'Authorization': token,
      };
      var request = http.Request('GET', Uri.parse('$server/user/policy/$type'));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        return LegalDocument.fromMap(
            decodedData["data"] as Map<String, dynamic>);
      } else {
        log(response.reasonPhrase.toString());
        throw Exception("Error fetching $type: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("get $type error: $e");
      throw Exception("Error fetching $type: $e");
    }
  }
}
