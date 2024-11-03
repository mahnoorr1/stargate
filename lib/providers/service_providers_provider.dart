// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stargate/utils/app_enums.dart';
import '../models/user.dart';
import '../services/service_providers.dart';

class AllUsersProvider extends ChangeNotifier {
  static AllUsersProvider c(BuildContext context, [bool listen = false]) =>
      Provider.of<AllUsersProvider>(context, listen: listen);
  static final AllUsersProvider _instance = AllUsersProvider._internal();

  factory AllUsersProvider() {
    return _instance;
  }

  AllUsersProvider._internal();

  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _loading = false;
  bool _noUsers = false;
  bool _initialLoadComplete = false;

  // Filter criteria
  String selectedCountry = '';
  String selectedCity = '';
  String selectedExperience = '';
  UserType? selectedUserType;

  List<User> get users => _users;
  List<User> get filteredUsers => _filteredUsers;
  bool get loading => _loading;
  bool get noUsers => _noUsers;

  Future<void> fetchUsers() async {
    if (_users.isEmpty && _initialLoadComplete) {
      _noUsers = true;
      notifyListeners();
      return;
    }

    if (_initialLoadComplete) {
      _checkForNewUsers();
      return;
    }

    _loading = true;
    _noUsers = false;
    notifyListeners();

    try {
      List<User> newUsers = await getAllServiceUsers();
      if (newUsers.isNotEmpty) {
        _updateUsers(newUsers);
      } else {
        _noUsers = true;
      }
    } catch (e) {
      _noUsers = true;
    } finally {
      _loading = false;
      _initialLoadComplete = true;
      notifyListeners();
    }
  }

  void _updateUsers(List<User> newUsers) {
    _users = newUsers;
    _filteredUsers = _users; // Start with all users
    _noUsers = _users.isEmpty;
    notifyListeners();
  }

  Future<void> _checkForNewUsers() async {
    try {
      List<User> newUsers = await getAllServiceUsers();
      final isEqual =
          const DeepCollectionEquality.unordered().equals(_users, newUsers);

      if (!isEqual) {
        _updateUsers(newUsers);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Failed to check for new users: $e");
    }
  }

  Future<void> filterUsers(
      String country, String city, String experience, UserType userType) async {
    selectedCountry = country;
    selectedCity = city;
    selectedExperience = experience;
    selectedUserType = userType;

    _loading = true; // Set loading to true while fetching
    notifyListeners();

    try {
      // Fetch filtered users from API based on criteria
      List<User> filteredUsers = await filterServiceUsers(
        country: selectedCountry,
        city: selectedCity,
        experience: selectedExperience,
        profession: selectedUserType!.name,
      );

      _filteredUsers = filteredUsers;
      _noUsers =
          _filteredUsers.isEmpty; // Update noUsers based on filtered results
    } catch (e) {
      _noUsers = true; // Handle errors by setting noUsers to true
    } finally {
      _loading = false; // Reset loading state
      notifyListeners();
    }
  }

  void resetFilters() {
    selectedCountry = '';
    selectedCity = '';
    selectedExperience = '';
    selectedUserType = null;
    _filteredUsers = _users; // Reset to display all users
    _noUsers = _filteredUsers.isEmpty; // Update _noUsers based on all users
    notifyListeners();
  }
}
