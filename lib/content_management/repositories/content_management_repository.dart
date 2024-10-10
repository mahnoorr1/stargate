import 'dart:convert';
import 'dart:developer';

import 'package:stargate/content_management/models/home_content_model.dart';
import 'package:stargate/content_management/models/listing_model.dart';
import 'package:stargate/content_management/models/offer_request_property_content_model.dart';

import '../../config/constants.dart';

import '../models/getting_started_model.dart';

import 'package:http/http.dart' as http;

import '../models/profile_content_model.dart';

class ContentManagementRepository {
  Future<List<GettingStartedModel>> getGettingStartedContent({
    required String token,
  }) async {
    try {
      var headers = {
        'Authorization': token,
      };
      var request =
          http.Request('GET', Uri.parse('$server/content/getting-started'));

      request.headers.addAll(headers);
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
}
