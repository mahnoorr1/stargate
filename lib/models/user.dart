import 'package:stargate/utils/app_enums.dart';

class User {
  String name;
  String image;
  List<Service> services;
  String address;
  String city;
  String country;
  bool verified;
  String email;

  User({
    required this.name,
    required this.image,
    required this.services,
    required this.address,
    required this.city,
    required this.country,
    this.verified = false,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      image: json['image'],
      services: (json['services'] as List)
          .map((service) => Service.fromJson(service))
          .toList(),
      address: json['address'],
      city: json['city'],
      country: json['country'],
      verified: json['verified'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'services': services.map((service) => service.toJson()).toList(),
      'address': address,
      'city': city,
      'country': country,
      'verified': verified,
      'email': email,
    };
  }

  getHighestExperience() {
    if (services.isEmpty) {
      return 0;
    }
    return services
        .map((service) => service.experience)
        .reduce((a, b) => a > b ? a : b);
  }

  bool containsServiceUserType(UserType userType) {
    return services.any((service) => service.userType == userType);
  }
}

class Service {
  UserType userType;
  String? serviceSubcategory;
  int experience;

  Service({
    required this.userType,
    required this.experience,
    this.serviceSubcategory,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      userType: UserType.values.firstWhere(
        // ignore: prefer_interpolation_to_compose_strings
        (e) => e.toString() == 'UserType.' + json['userType'],
      ),
      serviceSubcategory: json['serviceSubcategory'],
      experience: json['experience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType.toString().split('.').last,
      'experience': experience,
      'serviceSubcategory': serviceSubcategory,
    };
  }
}
