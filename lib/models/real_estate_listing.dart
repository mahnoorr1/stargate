class RealEstateListing {
  String title;
  String address;
  double price;
  String country;
  String city;
  String state;
  String description;
  String requestType; //'offer' or 'request'
  String condition;
  String propertyType; //'conventional' or 'commercial'
  String propertyCategory; //several types
  String propertySubCategory;
  String sellingType; //'rental' or 'purchase'
  int noOfBeds;
  int noOfBathrooms;
  List<String> pictures;
  bool furnished;
  bool? garage;
  double landAreaInTotal;
  double occupiedLandArea;
  String? equipment;
  String? qualityOfEquipment;
  int? parkingPlaces;

  RealEstateListing({
    required this.title,
    required this.address,
    required this.price,
    required this.country,
    required this.city,
    required this.state,
    required this.description,
    required this.requestType,
    required this.condition,
    required this.propertyType,
    required this.propertyCategory,
    required this.propertySubCategory,
    required this.sellingType,
    required this.noOfBeds,
    required this.noOfBathrooms,
    required this.pictures,
    required this.furnished,
    this.garage,
    required this.landAreaInTotal,
    required this.occupiedLandArea,
    this.equipment,
    this.qualityOfEquipment,
    this.parkingPlaces,
  });

  factory RealEstateListing.fromJson(Map<String, dynamic> json) {
    return RealEstateListing(
        title: json['title'],
        address: json['address'],
        price: json['price'],
        country: json['country'],
        city: json['city'],
        state: json['state'],
        description: json['description'],
        requestType: json['requestType'],
        condition: json['condition'],
        propertyType: json['propertyType'],
        propertyCategory: json['propertyCategory'],
        propertySubCategory: json['propertySubCategory'],
        sellingType: json['sellingType'],
        noOfBeds: json['noOfBeds'],
        noOfBathrooms: json['noOfBathrooms'],
        pictures: List<String>.from(json['pictures']),
        furnished: json['furnished'],
        garage: json['garage'],
        landAreaInTotal: json['landAreaInTotal'],
        occupiedLandArea: json['occupiedLandArea'],
        equipment: json['equipment'],
        qualityOfEquipment: json['qualityOfEquipment'],
        parkingPlaces: json['parkingPlaces']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address': address,
      'price': price,
      'country': country,
      'city': city,
      'state': state,
      'description': description,
      'requestType': requestType,
      'condition': condition,
      'propertyType': propertyType,
      'propertyCategory': propertyCategory,
      'propertySubCategory': propertySubCategory,
      'sellingType': sellingType,
      'noOfBeds': noOfBeds,
      'noOfBathrooms': noOfBathrooms,
      'pictures': pictures,
      'furnished': furnished,
      'garage': garage,
      'landAreaInTotal': landAreaInTotal,
      'occupiedLandArea': occupiedLandArea,
      'equipment': equipment,
      'qualityOfEquipment': qualityOfEquipment,
      'parkingPlaces': parkingPlaces,
    };
  }
}
