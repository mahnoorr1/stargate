import 'package:flutter/material.dart';
import '../models/getting_started_model.dart';
import '../repositories/content_management_repository.dart';

class GettingStartedProvider with ChangeNotifier {
  List<GettingStartedModel>? _gettingStartedContent;
  String? _errorMessage;
  bool _isLoading = false;

  List<GettingStartedModel>? get gettingStartedContent =>
      _gettingStartedContent;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchGettingStartedContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content =
          await ContentManagementRepository().getGettingStartedContent();
      _gettingStartedContent = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _gettingStartedContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
