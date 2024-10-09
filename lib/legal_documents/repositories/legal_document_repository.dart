import 'dart:convert';
import 'dart:developer';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:stargate/config/constants.dart';

import '../../services/helper_methods.dart';
import '../model/legal_document_model.dart';

Future<Either<AppFailure, LegalDocument>> getLegalDocument(
    {required String token, required String type}) async {
  try {
    var headers = {
      'Authorization': token,
    };
    var request = http.Request('GET', Uri.parse('$server/admin/policy/$type'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final decodedData = json.decode(await response.stream.bytesToString());

      return Right(
          LegalDocument.fromMap(decodedData["data"] as Map<String, dynamic>));
    } else {
      log(response.reasonPhrase.toString());
      return Left(AppFailure("Error fetching $type "));
    }
  } catch (e) {
    log("get $type  error: $e");
    return Left(AppFailure("Error fetching $type : $e"));
  }
}

Future<bool> updateLegalDocument({
  required String token,
  required String type,
  String? content,
  String? file,
}) async {
  try {
    var headers = {'Authorization': token};
    var request =
        http.MultipartRequest('POST', Uri.parse('$server/admin/policy/$type'));

    if (content != null) {
      request.fields.addAll({'content': content});
    }

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('file', file));
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String res = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      log("Update $type Response: $res");
      return true;
    } else {
      log("Update $type API Error: $res");
      return false;
    }
  } catch (error) {
    log('update$type Catched Error: $error');
    return false;
  }
}

Future<bool> deleteLegalDocument({
  required String token,
  required String type,
}) async {
  try {
    var headers = {'Authorization': token};
    var request =
        http.Request('DELETE', Uri.parse('$server/admin/policy/$type'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String res = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      log("Delete $type Response: $res");
      return true;
    } else {
      log("Delete $type API Error: $res");
      return false;
    }
  } catch (error) {
    log('Delete$type Catched Error: $error');
    return false;
  }
}
