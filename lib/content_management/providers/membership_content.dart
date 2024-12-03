import 'package:flutter/material.dart';
import 'package:stargate/models/membership.dart';
import '../repositories/content_management_repository.dart';

class MembershipContentProvider with ChangeNotifier {
  List<Membership>? _membershipContent;
  String? _errorMessage;
  bool _isLoading = false;

  List<Membership>? get membershipContent => _membershipContent;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchMembershipContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final content =
          await ContentManagementRepository().getMembershipContent();
      _membershipContent = content;
      print(content);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      print(e.toString());
      _membershipContent = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
