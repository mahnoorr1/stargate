import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  bool _onboardDone = false;

  bool get onboardDone => _onboardDone;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _onboardDone = prefs.getBool('onboardDone') ?? false;
    notifyListeners();
  }

  Future<void> setOnboardDone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardDone', value);
    _onboardDone = value;
    notifyListeners();
  }
}
