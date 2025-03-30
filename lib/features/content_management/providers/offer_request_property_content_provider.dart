import 'package:flutter/material.dart';
import '../models/offer_request_property_content_model.dart';
import '../repositories/content_management_repository.dart';

class OfferRequestPropertyContentProvider with ChangeNotifier {
  OfferRequestPropertyContentModel? _content;
  String? _errorMessage;
  bool _isLoading = false;

  OfferRequestPropertyContentModel? get content => _content;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchOfferRequestPropertyContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content =
          await ContentManagementRepository().getOfferRequestPropertyContent();
      _content = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _content = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
