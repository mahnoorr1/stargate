import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constants.dart';
import '../models/membership_model.dart';

class MembershipRepository {
  static Future<MembershipResponse> getMemberships() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accessToken') ?? '';

      var headers = {
        'Authorization': token,
      };

      var request = http.Request('GET', Uri.parse('$server/user/mymembership'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      log("API Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(responseBody);

        if (decodedData is Map<String, dynamic> &&
            decodedData.containsKey("message")) {
          var messageData = decodedData["message"];

          if (messageData is Map<String, dynamic>) {
            // The memberships are inside message.memberships
            if (messageData.containsKey("memberships") &&
                messageData["memberships"] is List) {
              List<dynamic> membershipsList = messageData["memberships"];
              List<Membership> memberships = membershipsList.map((item) {
                return Membership(
                    id: item["_id"] ?? "",
                    name: item["name"] ?? "",
                    identifier: item["identifier"] ?? "",
                    privileges: List<String>.from(item["privileges"] ?? []),
                    isActive: item["isActive"] ?? false,
                    isApplied: item["isApplied"] ?? false);
              }).toList();

              // Get the waiting period information
              Map<String, dynamic> waitingPeriod = {};
              if (messageData.containsKey("waitingPeriod") &&
                  messageData["waitingPeriod"] is Map<String, dynamic>) {
                waitingPeriod =
                    Map<String, dynamic>.from(messageData["waitingPeriod"]);
              } else {
                waitingPeriod = {'canApply': true, 'message': null};
              }

              return MembershipResponse(
                  memberships: memberships, waitingPeriod: waitingPeriod);
            }
          }
        }

        throw Exception("Unexpected API response format");
      } else {
        throw Exception("Error fetching memberships: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Get memberships error: $e");
      throw Exception("Error fetching memberships: $e");
    }
  }

  static Future<bool> applyForMembership(String membershipId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accessToken') ?? '';

      var headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      var request = http.Request(
          'POST',
          Uri.parse(
              'https://stargate-backend.vercel.app/api/v1/user/apply-membership'));

      request.body = json.encode({"membershipId": membershipId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      log("Apply API Status Code: ${response.statusCode}");
      log("Apply API Response: $responseBody");

      if (response.statusCode == 201) {
        // Return true to indicate success without trying to parse the response
        return true;
      } else {
        // Just log the error and return false
        log("Error applying for membership: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      log("Apply membership error: $e");
      return false;
    }
  }
}
