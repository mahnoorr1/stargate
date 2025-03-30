import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/membership_model.dart';
import '../repositories/membership_repository.dart';

class MembershipProvider with ChangeNotifier {
  MembershipResponse? _membershipData;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isApplying = false;

  MembershipResponse? get membershipData => _membershipData;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;

  List<Membership> get memberships => _membershipData?.memberships ?? [];
  bool get canApply => _membershipData?.waitingPeriod['canApply'] ?? false;
  String? get waitingMessage => _membershipData?.waitingPeriod['message'];

  Membership? get activeMembership {
    return memberships.firstWhere(
      (membership) => membership.isActive,
      orElse: () => memberships.first,
    );
  }

  Future<void> getMemberships() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _membershipData = await MembershipRepository.getMemberships();
    } catch (e) {
      _errorMessage = e.toString();
      log("Membership error: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> applyForMembership(String membershipId) async {
    _isApplying = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success =
          await MembershipRepository.applyForMembership(membershipId);

      if (success) {
        // Update the local membership data to reflect the application
        if (_membershipData != null) {
          final updatedMemberships =
              _membershipData!.memberships.map((membership) {
            if (membership.id == membershipId) {
              return Membership(
                id: membership.id,
                name: membership.name,
                identifier: membership.identifier,
                privileges: membership.privileges,
                isActive: membership.isActive,
                isApplied: {
                  'status': 'pending',
                  'appliedAt': DateTime.now().toIso8601String(),
                },
              );
            }
            return membership;
          }).toList();

          _membershipData = MembershipResponse(
            memberships: updatedMemberships,
            waitingPeriod: {
              'canApply': false,
              'message': 'You have a pending membership request'
            },
          );
        }
      }

      _isApplying = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      log("Apply membership error: $_errorMessage");
      _isApplying = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _membershipData = null;
    _errorMessage = null;
    _isLoading = false;
    _isApplying = false;
    notifyListeners();
  }
}
