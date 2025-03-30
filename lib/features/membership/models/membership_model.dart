// models/membership_model.dart
class Membership {
  final String id;
  final String name;
  final String identifier;
  final List<String> privileges;
  final bool isActive;
  final dynamic isApplied;
  Membership({
    required this.id,
    required this.name,
    required this.identifier,
    required this.privileges,
    required this.isActive,
    required this.isApplied,
  });

  factory Membership.fromMap(Map<String, dynamic> map) {
    return Membership(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      identifier: map['identifier'] ?? '',
      privileges: List<String>.from(map['privileges'] ?? []),
      isActive: map['isActive'] ?? false,
      isApplied: map['isApplied'],
    );
  }
}

class MembershipResponse {
  final List<Membership> memberships;
  final Map<String, dynamic> waitingPeriod;

  MembershipResponse({
    required this.memberships,
    required this.waitingPeriod,
  });

  factory MembershipResponse.fromMap(Map<String, dynamic> map) {
    return MembershipResponse(
      memberships: (map['memberships'] as List)
          .map((item) => Membership.fromMap(item))
          .toList(),
      waitingPeriod: Map<String, dynamic>.from(map['waitingPeriod'] ?? {}),
    );
  }
}

class MembershipApplicationResponse {
  final String requestId;
  final String membershipId;
  final String membershipName;
  final String status;
  final String appliedAt;

  MembershipApplicationResponse({
    required this.requestId,
    required this.membershipId,
    required this.membershipName,
    required this.status,
    required this.appliedAt,
  });

  factory MembershipApplicationResponse.fromMap(Map<String, dynamic> map) {
    return MembershipApplicationResponse(
      requestId: map['requestId'] ?? '',
      membershipId: map['membershipId'] ?? '',
      membershipName: map['membershipName'] ?? '',
      status: map['status'] ?? '',
      appliedAt: map['appliedAt'] ?? '',
    );
  }
}
