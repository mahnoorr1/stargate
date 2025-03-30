import 'package:flutter/material.dart';
import '../models/home_content_model.dart';
import '../repositories/content_management_repository.dart';

class HomeContentProvider with ChangeNotifier {
  HomeContentModel? _homeContent;
  String? _errorMessage;
  bool _isLoading = false;

  HomeContentModel? get homeContent => _homeContent;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchHomeContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content = await ContentManagementRepository().getHomeContent();
      _homeContent = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _homeContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
