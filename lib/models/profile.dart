import 'package:stargate/models/real_estate_listing.dart';
import 'package:stargate/utils/app_enums.dart';

class User {
  String id;
  String name;
  String? image;
  List<Service> services;
  String? address;
  String? city;
  String? country;
  bool? verified;
  String email;
  String? websiteLink;
  bool? restrictContact;
  List<RealEstateListing>? properties;
  List<dynamic>? references;
  String? membership;
  bool? isProfileCompleted;
  bool? isProfileApproved;
  String? status;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.services,
    required this.address,
    required this.city,
    required this.country,
    required this.email,
    this.verified,
    this.websiteLink,
    this.restrictContact,
    this.properties,
    this.references,
    this.membership,
    this.isProfileCompleted,
    this.isProfileApproved,
    this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print(json['profileStatus']);
    return User(
      id: json['_id'],
      name: json['name'] ?? '',
      image: json['profilePicture'] ?? '',
      services: (json['professions'] as List<dynamic>? ?? [])
          .map((profession) => Service.fromJson(profession))
          .toList(),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      email: json['email'] ?? '',
      verified: json['isRecommended'] ?? false,
      websiteLink: json['websiteLink'] ?? '',
      restrictContact: json['restrictContact'] ?? false,
      properties: (json['properties'] as List<dynamic>? ?? [])
          .map((property) => RealEstateListing.fromJson(
              property, json['email'], json['name'], json['_id']))
          .toList(),
      references: json['references'] as List<dynamic>,
      membership: json['membership']['_id'] as String,
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      isProfileApproved: json['isProfileApproved'] ?? false,
      status: json['profileStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profilePicture': image,
      'professions': services.map((service) => service.toJson()).toList(),
      'address': address,
      'city': city,
      'country': country,
      'verified': verified,
      'email': email,
      'websiteLink': websiteLink,
      'restrictContact': restrictContact,
      'properties': properties?.map((property) => property.toJson()).toList(),
      'isProfileCompleted': isProfileCompleted,
      'isProfileApproved': isProfileApproved,
    };
  }

  int getHighestExperience() {
    if (services.isEmpty) {
      return 0;
    }
    return services
        .map((service) => service.details['yearsOfExperience'] ?? 0)
        .reduce((a, b) => a > b ? a : b);
  }

  bool containsServiceUserType(UserType userType) {
    return services.any((service) =>
        service.details['name'].toString().toLowerCase() ==
        userType.toString().split('.').last.toLowerCase());
  }
}

class Service {
  Map<String, dynamic> details;

  Service({
    required this.details,
  });

  factory Service.fromJson(Map<String, dynamic> profession) {
    return Service(details: profession);
  }

  Map<String, dynamic> toJson() {
    return details;
  }
}
