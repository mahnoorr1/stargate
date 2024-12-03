import 'dart:convert';

import 'package:flutter/foundation.dart';

class Membership {
  String? id;
  String? identifier;
  String? tag;
  List<String>? points;
  Membership({
    required this.id,
    required this.identifier,
    required this.tag,
    required this.points,
  });

  Membership copyWith({
    String? tag,
    List<String>? points,
    String? identifier,
    String? id,
  }) {
    return Membership(
      identifier: identifier ?? this.identifier,
      id: id ?? this.id,
      tag: tag ?? this.tag,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'identifier': identifier,
      'tag': tag,
      'points': points,
    };
  }

  factory Membership.fromMap(Map<String, dynamic> map) {
    return Membership(
      id: map['_id'] ??
          '', // Fixed to match the actual field name in the response
      identifier: map['identifier'] ?? '',
      tag: map['name'] ?? '',
      points: map['privileges'] != null
          ? List<String>.from(map['privileges'] as List)
          : [], // Explicitly convert privileges to List<String>
    );
  }

  String toJson() => json.encode(toMap());

  factory Membership.fromJson(String source) =>
      Membership.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Membership(tag: $tag, points: $points)';

  @override
  bool operator ==(covariant Membership other) {
    if (identical(this, other)) return true;

    return other.tag == tag && listEquals(other.points, points);
  }

  @override
  int get hashCode => tag.hashCode ^ points.hashCode;
}
