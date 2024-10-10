import 'package:flutter/material.dart';
import '../model/listing_model.dart';
import '../repositories/content_management_repository.dart';

class ListingContentProvider with ChangeNotifier {
  ListingModel? _listingContent;
  String? _errorMessage;
  bool _isLoading = false;

  ListingModel? get listingContent => _listingContent;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchListingContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content = await ContentManagementRepository().getListingContent();
      _listingContent = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _listingContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
