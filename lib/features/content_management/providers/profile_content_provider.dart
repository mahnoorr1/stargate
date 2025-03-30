import 'package:flutter/material.dart';
import '../models/profile_content_model.dart';
import '../repositories/content_management_repository.dart';

class ProfileContentProvider with ChangeNotifier {
  ProfileContentModel? _profileContent;
  String? _errorMessage;
  bool _isLoading = false;

  ProfileContentModel? get profileContent => _profileContent;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchProfileContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content = await ContentManagementRepository().getProfileContent();
      _profileContent = content;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _profileContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
