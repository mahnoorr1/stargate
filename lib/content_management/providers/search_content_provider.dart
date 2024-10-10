import 'package:flutter/material.dart';
import '../repositories/content_management_repository.dart';

class SearchContentProvider with ChangeNotifier {
  String? _searchContent;
  String? _errorMessage;
  bool _isLoading = false;

  String? get searchContent => _searchContent;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchSearchContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content = await ContentManagementRepository().getSearchContent();
      _searchContent = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _searchContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
