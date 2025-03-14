import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';

Future<Map<String, String>> updateProperty({
  required String propertyId,
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
  required String landArea,
  required String buildingUsageArea,
  required String buildableArea,
  required String bathrooms,
  String? beds,
  String? rooms,
  required String price,
  String? isFurnished,
  String? garage,
  String? equipment,
  String? qualityOfEquipment,
  String? parkingPlaces,
  required List<String> newImagePaths, // Local file paths
  required List<String> existingImageUrls, // Existing API images
}) async {
  try {
    // Create API request
    var uri = Uri.parse("${server}property/edit/$propertyId");
    var request = http.MultipartRequest('PATCH', uri);

    // Add headers
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token!,
    };
    request.headers.addAll(headers);

    // Add fields
    request.fields.addAll({
      'title': title,
      'country': country,
      'offerType': requestType,
      'condition': condition,
      'purchaseType': purchaseType,
      'propertyType': propertyType,
      'price': price,
      'address': address ?? '',
      'city': city ?? '',
      'district': district ?? '',
      'shortDescription': shortDescription ?? '',
      'investmentType': investmentType!,
      'investmentSubcategory': investmentSubcategory!,
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
    print(existingImageUrls);
    for (int i = 0; i < existingImageUrls.length; i++) {
      request.fields['pictures[$i]'] = existingImageUrls[i];
    }

    // Add new local images
    for (String imagePath in newImagePaths) {
      File file = File(imagePath);
      if (await file.exists()) {
        request.files
            .add(await http.MultipartFile.fromPath('pictures', imagePath));
      } else {
        print("File not found: $imagePath");
      }
    }

    // Send request
    http.StreamedResponse response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseString);
      print(jsonResponse);
      return {
        "statusCode": jsonResponse["statusCode"]?.toString() ?? "Unknown",
        "message": jsonResponse["message"] ?? "No message",
      };
    } else {
      print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      var responseString = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseString);
      return {
        "statusCode": jsonResponse["statusCode"]?.toString() ?? "Unknown",
        "message": jsonResponse["message"] ?? "No message",
      };
    }
  } catch (e) {
    print("Exception: $e");
    return {};
  }
}
