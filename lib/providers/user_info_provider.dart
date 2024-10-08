import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  static UserProfileProvider c(BuildContext context, [bool listen = false]) =>
      Provider.of<UserProfileProvider>(context, listen: listen);
  static UserProfileProvider instance = UserProfileProvider._internal();

  factory UserProfileProvider() {
    return instance;
  }

  UserProfileProvider._internal() {
    _loadUserDetailsFromPrefs();
  }

  String _name = '';
  String _joiningDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String _countryName = '';
  String _cityName = '';
  String _email = '';
  String _token = '';

  String get name => _name;
  String get joiningDate => _joiningDate;
  String get countryName => _countryName;
  String get email => _email;
  String get token => _token;
  String get city => _cityName;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setJoiningDate(String joiningDate) {
    _joiningDate = joiningDate;
    notifyListeners();
  }

  void setCountryName(String countryName) {
    _countryName = countryName;
    notifyListeners();
  }

  void setCity(String city) {
    _cityName = city;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('accessToken') ?? '';
  }

  Future<void> _saveToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<void> _loadUserDetailsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('name') ?? _name;

    _joiningDate = prefs.getString('joiningDate') ?? _joiningDate;

    _countryName = prefs.getString('countryName') ?? _countryName;
    _cityName = prefs.getString('city') ?? _cityName;
    _email = prefs.getString('email') ?? _email;

    notifyListeners();
  }

  void setUserDetails({
    required String name,
    required String phone,
    required String joiningDate,
    required String countryName,
    required String email,
  }) {
    _name = name;
    _joiningDate = joiningDate;
    _countryName = countryName;
    _email = email;

    _saveToPrefs('name', name);
    _saveToPrefs('phone', phone);
    _saveToPrefs('joiningDate', joiningDate);
    _saveToPrefs('countryName', countryName);
    _saveToPrefs('email', email);

    notifyListeners();
  }

  Map<String, dynamic> getUserDetails() {
    _loadUserDetailsFromPrefs();
    return {
      'name': _name,
      'joiningDate': _joiningDate,
      'countryName': _countryName,
      'email': _email,
      'city': _cityName,
    };
  }

  void resetUserDetails() async {
    _name = '';
    _joiningDate = '';
    _countryName = '';
    _email = '';
    _token = '';
    _cityName = '';

    _saveToPrefs('name', '');
    _saveToPrefs('phone', '');
    _saveToPrefs('joiningDate', '');
    _saveToPrefs('countryName', '');
    _saveToPrefs('email', '');
    _saveToPrefs('city', '');
    _saveToPrefs('accessToken', '');
  }
}
