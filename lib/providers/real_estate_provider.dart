import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/services/real_estate_listings.dart';
import '../models/real_estate_listing.dart';
import '../services/property_update_api.dart';

class RealEstateProvider extends ChangeNotifier {
  static RealEstateProvider c(BuildContext context, [bool listen = false]) =>
      Provider.of<RealEstateProvider>(context, listen: listen);

  static final RealEstateProvider _instance = RealEstateProvider._internal();

  factory RealEstateProvider() {
    return _instance;
  }

  RealEstateProvider._internal() {
    _initializeProvider();
  }

  List<RealEstateListing> _allProperties = [];
  List<RealEstateListing> _filteredProperties = [];
  bool _loading = false;
  bool _noListings = false;
  bool _initialLoadComplete = false; // Flag for initial load

  // Filter criteria
  String selectedCountry = '';
  String selectedCity = '';
  String selectedOfferType = '';
  String selectedPriceRange = '';
  String selectedInvestmentType = '';
  String selectedInvestmentSubcategory = '';
  String selectedPurchaseType = '';
  String selectedCondition = '';
  String selectedPropertyType = '';

  List<RealEstateListing> get allProperties => _allProperties;
  List<RealEstateListing> get filteredProperties => _filteredProperties;
  bool get loading => _loading;
  bool get noListings => _noListings;

  Future<void> _initializeProvider() async {
    await fetchAllListings(initialLoad: true);
  }

  Future<void> fetchAllListings({bool initialLoad = false}) async {
    if (_initialLoadComplete && initialLoad) {
      _noListings = _allProperties.isEmpty;
      notifyListeners();
      return;
    }

    if (_initialLoadComplete) {
      await checkForNewListings();
      return;
    }

    _loading = true;
    _noListings = false;
    notifyListeners();

    try {
      List<RealEstateListing> listings = await getAllListings();
      if (listings.isNotEmpty) {
        _updateListings(listings, isInitialLoad: true);
      } else {
        _noListings = true;
      }
    } catch (e) {
      _noListings = true;
      if (kDebugMode) print(e.toString());
    } finally {
      _loading = false;
      _initialLoadComplete = true;
      notifyListeners();
    }
  }

  Future<void> checkForNewListings() async {
    try {
      List<RealEstateListing> newListings = await getAllListings();
      final isEqual = const DeepCollectionEquality.unordered()
          .equals(_allProperties, newListings);

      if (!isEqual) {
        _updateListings(newListings);
      }
    } catch (e) {
      if (kDebugMode) print("Failed to check for new listings: $e");
    }
  }

  void _updateListings(List<RealEstateListing> newListings,
      {bool isInitialLoad = false}) {
    if (isInitialLoad) {
      _allProperties = newListings;
    } else {
      for (var newListing in newListings) {
        if (!_allProperties.any((listing) => listing.id == newListing.id)) {
          _allProperties.add(newListing);
        }
      }
    }

    _filteredProperties = _allProperties;
    _noListings = _allProperties.isEmpty;
    notifyListeners();
  }

  Future<void> filterProperties({
    String? country,
    String? city,
    String? offerType,
    String? priceRange,
    String? investmentType,
    String? investmentSubcategory,
    String? purchaseType,
    String? condition,
    String? propertyType,
  }) async {
    selectedCountry = country ?? '';
    selectedCity = city ?? '';
    selectedOfferType = offerType ?? '';
    selectedPriceRange = priceRange ?? '';
    selectedInvestmentType = investmentType ?? '';
    selectedInvestmentSubcategory = investmentSubcategory ?? '';
    selectedPurchaseType = purchaseType ?? '';
    selectedCondition = condition ?? '';
    selectedPropertyType = propertyType ?? '';

    _loading = true;
    notifyListeners();

    try {
      _filteredProperties = await filterProperty(
        country: selectedCountry,
        city: selectedCity,
        offerType: selectedOfferType,
        priceRange: selectedPriceRange,
        investmentType: selectedInvestmentType,
        investmentSubcategory: selectedInvestmentSubcategory,
        purchaseType: selectedPurchaseType,
        condition: selectedCondition,
        propertyType: selectedPropertyType,
      );
      _noListings = _filteredProperties.isEmpty;
    } catch (e) {
      _noListings = true;
      if (kDebugMode) print(e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addProperty({
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
    Map<String, dynamic> result = await addPropertyRequest(
      title: title,
      address: address,
      country: country,
      district: district,
      city: city,
      shortDescription: shortDescription,
      requestType: requestType,
      condition: condition,
      purchaseType: purchaseType,
      propertyType: propertyType,
      investmentType: investmentType,
      investmentSubcategory: investmentSubcategory,
      landArea: landArea,
      buildingUsageArea: buildingUsageArea,
      buildableArea: buildableArea,
      bathrooms: bathrooms,
      beds: beds,
      rooms: rooms,
      price: price,
      isFurnished: isFurnished,
      garage: garage,
      equipment: equipment,
      qualityOfEquipment: qualityOfEquipment,
      parkingPlaces: parkingPlaces,
      pictures: pictures,
      postedBy: postedBy,
    );

    if (result['message'] == 'Property added successfully') {
      RealEstateListing newProperty = RealEstateListing(
        id: result['_id'],
        title: title,
        address: address!,
        price: price,
        country: country,
        city: city,
        landAreaInTotal: landArea,
        requestType: requestType,
        rooms: rooms,
        sellingType: purchaseType,
        propertyCategory: investmentType ?? '',
        propertySubCategory: investmentSubcategory ?? '',
        garage: garage ?? false,
        furnished: isFurnished ?? false,
        description: shortDescription ?? '',
        condition: condition,
        propertyType: propertyType,
        pictures: pictures,
        parkingPlaces: parkingPlaces,
        state: district,
        noOfBathrooms: bathrooms,
        userEmail: UserProfileProvider().email,
        userID: UserProfileProvider().id,
        userName: UserProfileProvider().name,
        status: result['status'],
      );

      notifyListeners();
      return result;
    } else {
      if (kDebugMode) print('Error adding property: $result');
      return {};
    }
  }

  Future<String> updateExistingProperty({
    required String propertyId,
    required String title,
    required String country,
    required String requestType,
    required String condition,
    required String purchaseType,
    required String propertyType,
    required String landArea,
    required String buildingUsageArea,
    required String buildableArea,
    required String bathrooms,
    required String price,
    List<String>? newImagePaths,
    List<String>? existingImageUrls,
    String? address,
    String? district,
    String? city,
    String? shortDescription,
    String? investmentType,
    String? investmentSubcategory,
    String? beds,
    String? rooms,
    String? isFurnished,
    String? garage,
    String? equipment,
    String? qualityOfEquipment,
    String? parkingPlaces,
  }) async {
    print(existingImageUrls);
    print(newImagePaths);
    // Call API
    Map<String, dynamic> result = await updateProperty(
      propertyId: propertyId,
      title: title,
      country: country,
      requestType: requestType,
      condition: condition,
      purchaseType: purchaseType,
      propertyType: propertyType,
      landArea: landArea,
      buildingUsageArea: buildingUsageArea,
      buildableArea: buildableArea,
      bathrooms: bathrooms,
      price: price,
      newImagePaths: newImagePaths ?? [],
      existingImageUrls: existingImageUrls ?? [],
      address: address,
      district: district,
      city: city,
      shortDescription: shortDescription,
      investmentType: investmentType,
      investmentSubcategory: investmentSubcategory,
      beds: beds,
      rooms: rooms,
      isFurnished: isFurnished,
      garage: garage,
      equipment: equipment,
      qualityOfEquipment: qualityOfEquipment,
      parkingPlaces: parkingPlaces,
    );
    print(result);

    if (result['message'] == 'Property updated successfully') {
      // Find and update the listing in provider
      int index =
          _allProperties.indexWhere((property) => property.id == propertyId);
      print("debugging 1");
      if (index != -1) {
        _allProperties[index] = RealEstateListing(
          id: propertyId,
          title: title,
          address: address ?? '',
          country: country,
          city: city ?? '',
          price: double.parse(price),
          requestType: requestType,
          condition: condition,
          sellingType: purchaseType,
          propertyType: propertyType,
          propertyCategory: investmentType ?? '',
          propertySubCategory: investmentSubcategory ?? '',
          landAreaInTotal: double.parse(landArea),
          rooms: rooms != null ? int.parse(rooms) : 0,
          noOfBathrooms: int.parse(bathrooms),
          garage: garage == 'yes',
          furnished: isFurnished == 'yes',
          description: shortDescription ?? '',
          pictures: [...?existingImageUrls, ...?newImagePaths],
          parkingPlaces: parkingPlaces != null ? int.parse(parkingPlaces) : 0,
          state: district ?? '',
          userID: UserProfileProvider().id,
          userEmail: UserProfileProvider().email,
          userName: UserProfileProvider().name,
          status: result['status'],
        );
        print("debugging 2");
        notifyListeners();
        print("debugging 3");
      }
      print("debugging 4");
      return result['message'];
    } else {
      print("debugging 5");
      return result['message'];
    }
  }

  void resetFilters() {
    selectedCountry = '';
    selectedCity = '';
    selectedOfferType = '';
    selectedPriceRange = '';
    selectedInvestmentType = '';
    selectedInvestmentSubcategory = '';
    selectedPurchaseType = '';
    selectedCondition = '';
    selectedPropertyType = '';
    _filteredProperties = _allProperties;
    _noListings = _filteredProperties.isEmpty;
    notifyListeners();
  }

  Future<void> deleteListing(String id) async {
    try {
      String result = await deleteProperty(id: id);
      if (result == 'Success') {
        _allProperties.removeWhere((listing) => listing.id == id);
        _filteredProperties = _allProperties;
        _noListings = _filteredProperties.isEmpty;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future<void> refreshListings() async {
    _initialLoadComplete = false;
    await fetchAllListings();
  }

  void deletePropertyInProvider(String id) {
    _allProperties.removeWhere((listing) => listing.id == id);
    _filteredProperties = _allProperties;
    _noListings = _allProperties.isEmpty;
    notifyListeners();
  }
}
