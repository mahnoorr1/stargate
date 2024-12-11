import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/config/constants.dart';
import 'package:stargate/models/profile.dart';

import '../models/notification_model.dart';

Future<String?> loginUser(String email, String pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var headers = {
    'Content-Type': 'application/json',
  };
  var request = http.Request('POST', Uri.parse('${server}user/login'));

  try {
    request.body = json.encode({"email": email, "password": pass});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      if (kDebugMode) {
        print(responseData);
      }
      String? token = responseData['data']['accessToken'] as String?;
      storeUserData(
        name: responseData['data']['user']['name'],
        email: email,
        id: responseData['data']['user']['_id'],
        membership: responseData['data']['user']['membership'],
        image: responseData['data']['user']['profilePicture'],
      );
      storeAccessToken(token!);
      String? tokenn = prefs.getString('accessToken');
      // ignore: avoid_print
      print(tokenn);
      saveDeviceToekn(userId: responseData['data']['user']['_id']);
      return 'token';
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      return errorMessage;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String?> registerUser(
  String name,
  String email,
  String pass,
  String profession,
) async {
  var headers = {
    'Content-Type': 'application/json',
  };
  var request = http.Request('POST', Uri.parse('${server}user/register'));

  try {
    request.body = json.encode({
      "name": name,
      "email": email,
      "password": pass,
      "profession": profession.toLowerCase(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonString = await response.stream.bytesToString();
      var responseData = jsonDecode(jsonString);
      String? code = responseData['message'];
      // storeUserData(
      //   name: responseData['data']['user']['name'],
      //   email: email,
      //   id: responseData['data']['user']['_id'],
      //   membership: responseData['data']['user']['membership']['_id'],
      // );
      // storeAccessToken(token!);
      return code;
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      return errorMessage;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
    return e.toString();
  }
}

Future<User?> myProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');

  if (token == null || token.isEmpty) {
    // Handle case where token is null or empty
    if (kDebugMode) {
      print('Access token is null or empty.');
    }
    return null;
  }

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token,
  };
  var request = http.Request('GET', Uri.parse('${server}user/my-profile'));

  try {
    request.body = '';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      String jsonString = await response.stream.bytesToString();
      final responseData = jsonDecode(jsonString);
      final user = User.fromJson(responseData['message']);
      return user;
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      if (kDebugMode) {
        print('Error: $errorMessage');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Exception: ${e.toString()}');
    }
    return null;
  }
}

// Future<String> updateProfile({
//   required String name,
//   required String address,
//   required String city,
//   required String country,
//   required List<Service> professions,
//   List<dynamic>? references, // Accepts both file paths and URLs
//   required String websiteLink,
//   String? profile, // Profile picture file path
// }) async {
//   // Retrieve the token
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('accessToken');

//   if (token == null) {
//     return 'Authorization token is missing';
//   }

//   // Setup headers
//   var headers = {
//     'Authorization': token,
//     'Cookie': 'accessToken=$token',
//   };

//   // Create multipart request
//   var request = http.MultipartRequest(
//     'PATCH',
//     Uri.parse('${server}user/update-profile'),
//   );

//   try {
//     // Add fields to the request
//     request.fields.addAll({
//       'name': name,
//       'address': address,
//       'city': city,
//       'country': country,
//       'websiteLink': websiteLink,
//     });

//     log('Request Fields: ${request.fields}');

//     // Add profile picture if provided
//     if (profile != null && profile.isNotEmpty) {
//       try {
//         request.files.add(
//           await http.MultipartFile.fromPath('profilePicture', profile),
//         );
//         log('Profile picture added: $profile');
//       } catch (e) {
//         log('Error adding profile picture: $e');
//       }
//     }

//     // Separate references into file paths and URLs
//     if (references != null && references.isNotEmpty) {
//       List<String> urls = [];
//       List<String> filePaths = [];

//       // Separate URLs and file paths
//       for (var ref in references) {
//         if (ref.toString().startsWith('http')) {
//           urls.add(ref); // Add to URLs list
//         } else {
//           filePaths.add(ref); // Add to file paths list
//         }
//       }

//       // Add URLs to fields
//       for (int i = 0; i < urls.length; i++) {
//         request.fields['references[$i]'] = urls[i];
//         log('Added URL reference: ${urls[i]}');
//       }

//       // Add files as MultipartFile
//       for (var filePath in filePaths) {
//         try {
//           request.files.add(
//             await http.MultipartFile.fromPath('references', filePath),
//           );
//           log('Added file reference: $filePath');
//         } catch (e) {
//           log('Error adding file reference $filePath: $e');
//         }
//       }
//     }

//     // Add headers
//     request.headers.addAll(headers);

//     log('Request Files: ${request.files}');
//     log('Request Fields: ${request.fields}');

//     // Send the request
//     http.StreamedResponse response = await request.send();

//     // Process the response
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       String jsonString = await response.stream.bytesToString();
//       final Map<String, dynamic> responseData = jsonDecode(jsonString);

//       log('Update Profile Success: $responseData');

//       // Update local user data
//       storeUserData(
//         name: responseData['data']['name'],
//         email: responseData['data']['email'],
//         id: responseData['data']['_id'],
//         membership: responseData['data']['membership'],
//       );

//       // Update professions separately
//       String profession = await updateProfessions(

Future<String> updateProfile({
  required String name,
  required String address,
  required String city,
  required String country,
  required List<Service> professions,
  List<dynamic>? references, // Accepts both file paths and URLs
  required String websiteLink,
  String? profile, // Profile picture file path
}) async {
  // Retrieve the token
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');

  if (token == null) {
    return 'Authorization token is missing';
  }

  final headers = {
    'Authorization': token,
    'Cookie': 'accessToken=$token',
  };

  final request = http.MultipartRequest(
    'PATCH',
    Uri.parse('${server}user/update-profile'),
  );

  try {
    // Add basic fields
    request.fields.addAll({
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'websiteLink': websiteLink,
    });

    // Add profile picture if provided
    if (profile != null && profile.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('profilePicture', profile));
    }

    // Separate and handle references
    if (references != null && references.isNotEmpty) {
      final List<String> urls = [];
      final List<String> filePaths = [];

      for (var ref in references) {
        if (ref.toString().startsWith('http')) {
          urls.add(ref);
        } else {
          filePaths.add(ref);
        }
      }

      for (int i = 0; i < urls.length; i++) {
        request.fields['references[$i]'] = urls[i];
      }

      for (var filePath in filePaths) {
        request.files
            .add(await http.MultipartFile.fromPath('references', filePath));
      }
    }

    // Add headers
    request.headers.addAll(headers);

    // Send the request
    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String jsonString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(jsonString);

      storeUserData(
        name: responseData['data']['name'],
        email: responseData['data']['email'],
        id: responseData['data']['_id'],
        membership: responseData['data']['membership'],
      );

      // Extract references from the response and update professions
      final List<dynamic> updatedReferences =
          List<dynamic>.from(responseData['data']['references'] ?? []);
      final String professionUpdateStatus = await updateProfessions(
        professions: professions,
        references:
            updatedReferences, // Passing references from profile update response
      );

      return professionUpdateStatus == 'Success' ? 'Success' : 'Error';
    } else {
      final String errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;

      log('Update Profile Failed: $errorMessage');
      return errorMessage;
    }
  } catch (e) {
    log('Update Profile Error: $e');
    return e.toString();
  }
}

Future<String> updateProfessions({
  required List<Service> professions,
  required List<dynamic> references,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');

  if (token == null) {
    return 'Authorization token is missing';
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': token,
  };

  final request = http.Request(
    'PATCH',
    Uri.parse('${server}user/update-profile'),
  );

  try {
    // Add professions and references to the body
    request.body = jsonEncode({
      "professions": professions.map((item) {
        if (item.details['name'].toLowerCase() == 'investor') {
          return {
            "name": item.details['name'],
            "investmentRange": {
              "min": item.details['investmentRange']['min'],
              "max": item.details['investmentRange']['max'],
            },
            "specialization": item.details['specialization'] ?? "",
            "preferredInvestmentCategories": List<String>.from(
              item.details['preferredInvestmentCategories'] ?? [],
            ),
          };
        } else {
          return {
            "name": item.details['name'],
            "specialization": item.details['specialization'] ?? "",
            "yearsOfExperience": item.details['yearsOfExperience'] ?? 0,
          };
        }
      }).toList(),
      "references":
          references, // References passed from profile update response
    });

    request.headers.addAll(headers);

    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Success';
    } else {
      final String errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;

      log('Update Professions Failed: $errorMessage');
      return errorMessage;
    }
  } catch (e) {
    log('Update Professions Error: $e');
    return e.toString();
  }
}

Future<String> changePassword(
  String currentPass,
  String newPass,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };
  var request =
      http.Request('POST', Uri.parse('${server}user/change-password'));
  request.body = json.encode({
    "currentPassword": currentPass,
    "newPassword": newPass,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200 || response.statusCode == 201) {
    return "Password Changed Successfully!";
  } else {
    final errorResponse = await response.stream.bytesToString();
    final Map<String, dynamic> errorData = jsonDecode(errorResponse);
    final String errorMessage = errorData['message'] as String;
    return errorMessage;
  }
}

Future<String> forgetPassword(
  String email,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };
  var request =
      http.Request('POST', Uri.parse('${server}user/forgot-password'));
  request.body = json.encode({
    "email": email,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200 || response.statusCode == 201) {
    final stringResponse = await response.stream.bytesToString();
    final Map<String, dynamic> data = jsonDecode(stringResponse);
    return data['message'];
  } else {
    final errorResponse = await response.stream.bytesToString();
    final Map<String, dynamic> errorData = jsonDecode(errorResponse);
    final String errorMessage = errorData['message'] as String;
    return errorMessage;
  }
}

Future<String> resetForgottenPassword(
  String email,
  String newPass,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token!,
  };
  var request = http.Request('POST', Uri.parse('${server}user/reset-password'));
  request.body = json.encode({
    "email": email,
    "newPassword": newPass,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200 || response.statusCode == 201) {
    return "Password Changed, Login to Continue!";
  } else {
    final errorResponse = await response.stream.bytesToString();
    final Map<String, dynamic> errorData = jsonDecode(errorResponse);
    final String errorMessage = errorData['message'] as String;
    return errorMessage;
  }
}

void storeAccessToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', token);
}

void deleteAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', '');
}

void storeUserData({
  required String name,
  required String email,
  required String id,
  String? image,
  required String membership,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profile', image ?? '');
  prefs.setString('id', id);
  prefs.setString('name', name);
  prefs.setString('email', email);
  prefs.setString('membership', membership);
}

void deleteUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profile', '');
  prefs.setString('id', '');
  prefs.setString('name', '');
  prefs.setString('email', '');
  prefs.setString('membership', '');
}

Future<String> verifyOTP(String otp, String email) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse('${server}user/verify-otp'));

  try {
    request.body = json.encode({
      "otp": otp,
      "email": email,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "Email verified, login to continue!";
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      log(errorData.toString());
      return errorMessage;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> verifyForgetPassOTP(String otp, String email) async {
  var headers = {'Content-Type': 'application/json'};
  var request =
      http.Request('POST', Uri.parse('${server}user/verify-password-otp'));

  try {
    request.body = json.encode({
      "otp": otp,
      "email": email,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return "Email verified!";
    } else {
      final errorResponse = await response.stream.bytesToString();
      final Map<String, dynamic> errorData = jsonDecode(errorResponse);
      final String errorMessage = errorData['message'] as String;
      log(errorData.toString());
      return errorMessage;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<void> saveDeviceToekn({
  required String userId,
}) async {
  try {
    var deviceToken = await FirebaseMessaging.instance.getToken();
    log('Token: $deviceToken');
    log('------------------------------------');

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('${server}user/save-device-token'));
    request.body = json.encode({
      "userId": userId,
      "deviceToken": deviceToken,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      log('Device Token Saved Successfully');
    } else {
      log(response.reasonPhrase.toString());
    }
  } catch (error) {
    log('saveDeviceToekn Catched Error: $error');
  }
}

Future<List<NotificationModel>> getNotifications() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Access token not found");
    }

    var headers = {
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse('${server}user/notifications'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse the response body
      final List<dynamic> notificationsJson =
          json.decode(response.body)['data'];

      // Map each JSON object to a Notification model
      List<NotificationModel> notifications = notificationsJson
          .map((notification) => NotificationModel.fromMap(notification))
          .toList();

      log("Notifications retrieved: $notifications");
      return notifications;
    } else {
      log("Failed to fetch notifications: ${response.reasonPhrase}");
      return [];
    }
  } catch (error) {
    log('getNotifications Catched Error: $error');
    return [];
  }
}
