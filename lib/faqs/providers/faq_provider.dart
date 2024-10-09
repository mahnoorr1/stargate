import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stargate/faqs/repositories/faq_remote_repository.dart';

import '../model/faq_model.dart';
import 'package:flutter/material.dart';

class FaqProvider with ChangeNotifier {
  List<FAQ>? _faqs;
  String? _errorMessage;
  bool _isLoading = false;

  List<FAQ>? get faqs => _faqs;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> getFAQs() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('accessToken') ?? '';

      _faqs = await FaqRemoteRepository.getFAQs(token: token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      log(_errorMessage!.toString());
      _faqs = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
