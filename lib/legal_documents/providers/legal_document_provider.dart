import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/legal_document_model.dart';
import '../repositories/legal_document_repository.dart';

class LegalDocumentProvider with ChangeNotifier {
  LegalDocument? _legalDocument;
  String? _errorMessage;
  bool _isLoading = false;

  LegalDocument? get legalDocument => _legalDocument;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> getLegalDocument({required String type}) async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accessToken') ?? '';

    try {
      final legalDocument = await LegalDocumentRepository.getLegalDocument(
          token: token, type: type);
      _legalDocument = legalDocument;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _legalDocument = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
