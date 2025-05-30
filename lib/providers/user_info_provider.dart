import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/services/real_estate_listings.dart';
import 'package:stargate/services/user_profiling.dart';
import '../models/profile.dart';
import '../models/real_estate_listing.dart';

class UserProfileProvider with ChangeNotifier {
  static UserProfileProvider c(BuildContext context, [bool listen = false]) =>
      Provider.of<UserProfileProvider>(context, listen: listen);
  static final UserProfileProvider instance = UserProfileProvider._internal();

  factory UserProfileProvider() {
    return instance;
  }

  UserProfileProvider._internal() {
    _loadUserDetailsFromPrefs();
    _loadInitialProfileData();
  }

  String _name = '';
  String _id = '';
  String _joiningDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _countryName = '';
  String _address = '';
  String _cityName = '';
  String _email = '';
  String _token = '';
  String? _profileImage;
  bool _verified = false;
  String? _websiteLink;
  bool _restrictContact = false;
  List<Service> _services = [];
  List<RealEstateListing> _properties = [];
  List<dynamic> _references = [];
  bool _isLoading = true;
  bool _firstProfileInfoAlertDone = false;
  String _membership = '';
  bool _isProfileCompleted = false;
  bool _isProfileApproved = false;
  String _status = 'pending';

  String get id => _id;
  String get name => _name;
  String get joiningDate => _joiningDate;
  String get countryName => _countryName;
  String get address => _address;
  String get city => _cityName;
  String get email => _email;
  String get token => _token;
  String? get profileImage => _profileImage;
  bool get verified => _verified;
  String? get websiteLink => _websiteLink;
  bool get restrictContact => _restrictContact;
  List<Service> get services => _services;
  List<RealEstateListing> get properties => _properties;
  List<dynamic> get references => _references;
  bool get isLoading => _isLoading;
  bool get firstProfileInfoAlertDone => _firstProfileInfoAlertDone;
  String get membership => _membership;
  bool get isProfileCompleted => _isProfileCompleted;
  bool get isProfileApproved => _isProfileApproved;
  String get status => _status;

  Future<void> _loadInitialProfileData() async {
    _isLoading = true;
    notifyListeners();

    await fetchUserProfile();
    _isLoading = false;
    notifyListeners();
  }

  void setFirstTimeAlert() {
    _firstProfileInfoAlertDone = true;
    notifyListeners();
  }

  void setMembership(String membership) {
    _membership = membership;
    notifyListeners();
  }

  void setEmail(String email) async {
    _email = email;
    await _saveToPrefs('email', _email);
    notifyListeners();
  }

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    User? user = await myProfile();
    if (user != null) {
      _id = user.id;
      _name = user.name;
      _profileImage = user.image;
      _services = user.services;
      _countryName = user.country ?? '';
      _address = user.address ?? '';
      _cityName = user.city ?? '';
      _email = user.email;
      _verified = user.verified ?? false;
      _websiteLink = user.websiteLink;
      _restrictContact = user.restrictContact ?? false;
      _properties = user.properties ?? [];
      _references = user.references ?? [];
      _membership = user.membership ?? '';
      _isProfileCompleted = user.isProfileCompleted ?? false;
      _isProfileApproved = user.isProfileApproved ?? false;
      _status = user.status ?? 'pending';

      await _saveToPrefs('id', _id);
      await _saveToPrefs('name', _name);
      await _saveToPrefs('profileImage', _profileImage ?? '');
      await _saveToPrefs('countryName', _countryName);
      await _saveToPrefs('address', _address);
      await _saveToPrefs('city', _cityName);
      await _saveToPrefs('email', _email);
      await _saveToPrefs('verified', _verified.toString());
      await _saveToPrefs('websiteLink', _websiteLink ?? '');
      await _saveToPrefs('restrictContact', _restrictContact.toString());
      await _saveToPrefs('membership', _membership);

      _isLoading = false;

      notifyListeners();
    }
  }

  Future<String> updateUserProfile({
    required String name,
    required String address,
    required String city,
    required String country,
    required List<Service> professions,
    required List<dynamic> references,
    required String websiteLink,
    String? profileImage,
  }) async {
    String result = await updateProfile(
      name: name,
      address: address,
      city: city,
      country: country,
      professions: professions,
      references: references,
      websiteLink: websiteLink,
      profile: profileImage,
    );
    if (result == 'Success') {
      await fetchUserProfile();
      return 'Success';
    } else {
      return '';
    }
  }

  // Future<void> updateProfession(List<Service> newProfessions) async {
  //   String result = await updateProfessions(professions: newProfessions);
  //   if (result == 'Success') {
  //     _services = newProfessions;
  //     notifyListeners();
  //   } else {
  //     //
  //   }
  // }

  Future<void> deleteUserProperty(String propertyId) async {
    String result = await deleteProperty(id: propertyId);
    if (result == 'Success') {
      _properties.removeWhere((property) => property.id == propertyId);
      notifyListeners();
    } else {
      //
    }
  }

  Future<void> _saveToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> _loadUserDetailsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _id = prefs.getString('id') ?? _id;
    _name = prefs.getString('name') ?? _name;
    _profileImage = prefs.getString('profileImage') ?? _profileImage;
    _countryName = prefs.getString('countryName') ?? _countryName;
    _address = prefs.getString('address') ?? _address;
    _cityName = prefs.getString('city') ?? _cityName;
    _email = prefs.getString('email') ?? _email;
    _verified = prefs.getBool('verified') ?? _verified;
    _websiteLink = prefs.getString('websiteLink') ?? _websiteLink;
    _restrictContact = prefs.getBool('restrictContact') ?? _restrictContact;
    _membership = prefs.getString('membership') ?? _membership;

    notifyListeners();
  }

  bool incompleteProfile() {
    if (!isProfileCompleted
        // countryName == '' ||
        //   address == '' ||
        //   profileImage == '' ||
        //   (services.isEmpty ||
        //       services[0].details['yearsOfExperience'] == '' ||
        //       services[0].details['yeasOfExperience'] == null ||
        //       services[0].details['specialization'] == '' ||
        //       services[0].details['specialization'] == null)
        ) {
      print("Incomplete Profile");
      return true;
    }
    print("Complete Profile");
    return false;
  }

  bool profileApproved() {
    if (status != 'approved') {
      return false;
    }
    return true;
  }

  void setUserDetails({
    required String name,
    required String joiningDate,
    required String countryName,
    required String email,
  }) {
    _name = name;
    _joiningDate = joiningDate;
    _countryName = countryName;
    _email = email;

    _saveToPrefs('name', name);
    _saveToPrefs('joiningDate', joiningDate);
    _saveToPrefs('countryName', countryName);
    _saveToPrefs('email', email);

    notifyListeners();
  }

  Map<String, dynamic> getUserDetails() {
    return {
      'name': _name,
      'joiningDate': _joiningDate,
      'countryName': _countryName,
      'email': _email,
      'city': _cityName,
    };
  }

  void resetUserDetails() async {
    _id = '';
    _name = '';
    _joiningDate = '';
    _countryName = '';
    _address = '';
    _email = '';
    _token = '';
    _cityName = '';
    _profileImage = null;
    _verified = false;
    _websiteLink = null;
    _restrictContact = false;
    _services = [];
    _properties = [];
    _references = [];
    _membership = '';

    await _saveToPrefs('id', '');
    await _saveToPrefs('name', '');
    await _saveToPrefs('profileImage', '');
    await _saveToPrefs('countryName', '');
    await _saveToPrefs('address', '');
    await _saveToPrefs('city', '');
    await _saveToPrefs('email', '');
    await _saveToPrefs('accessToken', '');
    await _saveToPrefs('verified', 'false');
    await _saveToPrefs('websiteLink', '');
    await _saveToPrefs('restrictContact', 'false');
    await _saveToPrefs('membership', '');

    notifyListeners();
  }
}
