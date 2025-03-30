import 'dart:convert';
import 'dart:developer';

import 'package:stargate/features/content_management/models/home_content_model.dart';
import 'package:stargate/features/content_management/models/listing_model.dart';
import 'package:stargate/features/content_management/models/offer_request_property_content_model.dart';
import 'package:stargate/models/membership.dart';

import '../../../config/constants.dart';

import '../models/getting_started_model.dart';

import 'package:http/http.dart' as http;

import '../models/profile_content_model.dart';

class ContentManagementRepository {
  Future<List<GettingStartedModel>> getGettingStartedContent() async {
    try {
      var request =
          http.Request('GET', Uri.parse('$server/content/getting-started'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        log("Getting Started Content: OK Responce");

        return (decodedData["data"] as List)
            .map((item) =>
                GettingStartedModel.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error getting GetStartedContent: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error getting GetStartedContent: $e");
      throw Exception("Error getting GetStartedContent: $e");
    }
  }

  Future<OfferRequestPropertyContentModel>
      getOfferRequestPropertyContent() async {
    try {
      var request =
          http.Request('GET', Uri.parse('$server/content/offer-request'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        log("Offer Request Property Content: OK Responce");
        return OfferRequestPropertyContentModel.fromMap(
            decodedData["data"] as Map<String, dynamic>);
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error fetching offer request content: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("get offer request property content error: $e");
      throw Exception("Error fetching offer request content: $e");
    }
  }

  Future<HomeContentModel> getHomeContent() async {
    try {
      var request = http.Request('GET', Uri.parse('$server/content/home'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        log("Home Content: OK Responce");

        return HomeContentModel(
          picture: decodedData["data"]["propertyOfferContent"]["picture"],
          title: decodedData["data"]["propertyOfferContent"]["title"],
          subtitle: decodedData["data"]["propertyOfferContent"]["subtitle"],
          tagline: decodedData["data"]["propertyOfferContent"]["tagline"],
          drawerIcon: decodedData["data"]["drawerIcon"],
          homeIcon: decodedData["data"]["homeIcon"],
          appLogo: decodedData["data"]["appLogo"],
        );
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error fetching Home content: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("get Home content error: $e");
      throw Exception("Error fetching Home content: $e");
    }
  }

  Future<ListingModel> getListingContent() async {
    try {
      var request = http.Request('GET', Uri.parse('$server/content/listings'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        log("Listing Content: OK Responce");

        return ListingModel.fromMap(
            decodedData["data"] as Map<String, dynamic>);
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error fetching listing content: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("get listing content error: $e");
      throw Exception("Error fetching listing content: $e");
    }
  }

  Future<String> getSearchContent() async {
    try {
      var request = http.Request('GET', Uri.parse('$server/content/search'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        final String searchIcon = decodedData["data"]["searchIcon"];
        log("Search Content: OK Responce");

        return searchIcon;
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error fetching Search content: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("get Search content error: $e");
      throw Exception("Error fetching Search content: $e");
    }
  }

  Future<ProfileContentModel> getProfileContent() async {
    try {
      var request = http.Request('GET', Uri.parse('$server/content/profile'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        print(decodedData);
        log("Profile Content: OK Responce");

        return ProfileContentModel.fromMap(decodedData as Map<String, dynamic>);
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error fetching profile content: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error fetching profile content: $e");
      throw Exception("Error fetching profile content: $e");
    }
  }

  Future<List<Membership>> getMembershipContent() async {
    try {
      var request =
          http.Request('GET', Uri.parse('$server/content/memberships'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final decodedData = json.decode(await response.stream.bytesToString());
        log("Membership Content: OK Response");

        // Explicitly cast the map result to List<Membership>
        final memberships = (decodedData['data'] as List)
            .map((json) => Membership.fromMap(json as Map<String, dynamic>))
            .toList();

        memberships.sort((a, b) {
          if (a.identifier == 'free_trial') {
            return -1; // Move 'free_trial' to the top
          }
          if (b.identifier == 'free_trial') {
            return 1; // Keep 'free_trial' on top
          }

          if (a.identifier == 'restricted_access') {
            return 1; // Move 'restricted_access' to the bottom
          }
          if (b.identifier == 'restricted_access') {
            return -1; // Keep 'restricted_access' at the bottom
          }

          return 0; // Preserve order for others
        });

        return memberships;
      } else {
        log(response.reasonPhrase.toString());
        throw Exception(
            "Error fetching membership content: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error fetching membership content: $e");
      throw Exception("Error fetching membership content: $e");
    }
  }
}
