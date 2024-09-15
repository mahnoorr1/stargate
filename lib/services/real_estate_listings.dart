import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/models/real_estate_listing.dart';
import 'package:http/http.dart' as http;

Future<List<RealEstateListing>> getAllListings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': "accessToken=${token!}",
  };

  try {
    var request = http.Request('GET', Uri.parse('${server}property/'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      try {
        final decodedData = jsonDecode(jsonString);

        if (decodedData is Map<String, dynamic>) {
          final List<dynamic> data = decodedData['data'];
          if (data.isNotEmpty) {
            final listings = data.map((json) {
              return RealEstateListing.fromJson(
                json,
                prefs.getString('email'),
                prefs.getString('name'),
                prefs.getString('id'),
              );
            }).toList();
            return listings;
          } else {
            return [];
          }
        } else {
          throw Exception(
              'Unexpected JSON structure: ${decodedData.runtimeType}');
        }
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('Failed to get listings: ${response.statusCode}');
    }
  } catch (e) {
    return [];
  }
}

Future<String> addPropertyRequest({
  required String title,
  String? address,
  required String country,
  String? district,
  String? city,
  String? shortDescription,
  required String requestType,
  required String condition,
  required String purchaseType,
  required String propertyType,
  String? investmentType,
  String? investmentSubcategory,
  required double landArea,
  required double buildingUsageArea,
  required double buildableArea,
  required int bathrooms,
  int? beds,
  int? rooms,
  required double price,
  bool? isFurnished,
  bool? garage,
  String? equipment,
  String? qualityOfEquipment,
  int? parkingPlaces,
  required List<String> pictures,
  required String postedBy,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': "accessToken=${token!}",
  };

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${server}property/offer-or-request-property'),
  );

  request.headers.addAll(headers);
  request.fields.addAll({
    'title': title,
    'address': address ?? '',
    'price': price.toString(),
    'country': country,
    'city': city ?? '',
    'district': district ?? '',
    'shortDescription': shortDescription ?? '',
    'offerType': requestType,
    'condition': condition,
    'propertyType': propertyType,
    'investmentType': investmentType!,
    'investmentSubcategory': investmentSubcategory!,
    'purchaseType': purchaseType,
    'beds': beds.toString(),
    'rooms': rooms.toString(),
    'bathrooms': bathrooms.toString(),
    'isFurnished': isFurnished.toString(),
    'garage': garage.toString(),
    'landArea': landArea.toString(),
    'buildingUsageArea': buildingUsageArea.toString(),
    'buildableArea': buildableArea.toString(),
    'equipment': equipment ?? '',
    'qualityOfEquipment': qualityOfEquipment ?? '',
    'numberOfParkingPlaces': parkingPlaces.toString(),
  });
  for (int i = 0; i < pictures.length; i++) {
    String filePath = pictures[i];
    String mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

    request.files.add(
      await http.MultipartFile.fromPath(
        'pictures',
        filePath,
        contentType: MediaType.parse(mimeType),
      ),
    );
  }

  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Success';
    } else {
      String responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      String message = data['message'];
      return message;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> deleteProperty({
  required String id,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': "accessToken=${token!}",
  };
  var request = http.Request('DELETE', Uri.parse('${server}property/$id'));
  try {
    request.body = '';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Success';
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      if (kDebugMode) {
        print(errorMessage);
      }
      return '';
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return '';
  }
}
