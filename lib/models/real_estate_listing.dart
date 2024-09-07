class RealEstateListing {
  String? id;
  String title;
  String address;
  double price;
  String country;
  String? city;
  String? state;
  String description;
  String requestType;
  String condition;
  String propertyType;
  String propertyCategory;
  String propertySubCategory;
  String sellingType;
  int? noOfBeds;
  int? rooms;
  int noOfBathrooms;
  List<String> pictures;
  bool? furnished;
  bool? garage;
  double? landAreaInTotal;
  double? occupiedLandArea;
  double? buildableArea;
  String? equipment;
  String? qualityOfEquipment;
  int? parkingPlaces;

  RealEstateListing({
    this.id,
    required this.title,
    required this.address,
    required this.price,
    required this.country,
    this.city,
    this.state,
    required this.description,
    required this.requestType,
    required this.condition,
    required this.propertyType,
    required this.propertyCategory,
    required this.propertySubCategory,
    required this.sellingType,
    this.noOfBeds,
    this.rooms,
    required this.noOfBathrooms,
    required this.pictures,
    this.furnished,
    this.garage,
    this.landAreaInTotal,
    this.occupiedLandArea,
    this.buildableArea,
    this.equipment,
    this.qualityOfEquipment,
    this.parkingPlaces,
  });

  factory RealEstateListing.fromJson(Map<String, dynamic> json) {
    return RealEstateListing(
      id: json['_id'],
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      state: json['district'] ?? '',
      description: json['shortDescription'] ?? '',
      requestType: json['offerType'] ?? '',
      condition: json['condition'] ?? '',
      propertyType: json['propertyType'] ?? '',
      propertyCategory: json['investmentType'] ?? '',
      propertySubCategory: json['investmentSubcategory'] ?? '',
      sellingType: json['purchaseType'] ?? '',
      noOfBeds: json['beds'] ?? 0,
      rooms: json['rooms'] ?? 0,
      noOfBathrooms: json['bathrooms'] ?? 0,
      pictures: List<String>.from(json['pictures'] ?? []),
      furnished: json['isFurnished'] ?? false,
      garage: json['garage'] ?? false,
      landAreaInTotal: json['landArea']?.toDouble() ?? 0.0,
      occupiedLandArea: json['buildingUsageArea']?.toDouble() ?? 0.0,
      buildableArea: json['buildableArea']?.toDouble() ?? 0.0,
      equipment: json['equipment'] ?? '',
      qualityOfEquipment: json['qualityOfEquipment'] ?? '',
      parkingPlaces: json['numberOfParkingPlaces'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address': address,
      'price': price,
      'country': country,
      'city': city,
      'district': state,
      'shortDescription': description,
      'offerType': requestType,
      'condition': condition,
      'propertyType': propertyType,
      'investmentType': propertyCategory,
      'investmentSubCategory': propertySubCategory,
      'purchaseType': sellingType,
      'beds': noOfBeds,
      'rooms': rooms,
      'bathrooms': noOfBathrooms,
      'pictures': pictures,
      'isFurnished': furnished,
      'garage': garage,
      'landArea': landAreaInTotal,
      'buildingUsageArea': occupiedLandArea,
      'buildableArea': buildableArea,
      'equipment': equipment,
      'qualityOfEquipment': qualityOfEquipment,
      'numberOfParkingPlaces': parkingPlaces,
    };
  }
}
