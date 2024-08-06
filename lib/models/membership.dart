import 'dart:convert';

import 'package:flutter/foundation.dart';

class Membership {
  String tag;
  List<String> points;
  Membership({
    required this.tag,
    required this.points,
  });

  Membership copyWith({
    String? tag,
    List<String>? points,
  }) {
    return Membership(
      tag: tag ?? this.tag,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tag': tag,
      'points': points,
    };
  }

  factory Membership.fromMap(Map<String, dynamic> map) {
    return Membership(
        tag: map['tag'] as String,
        points: List<String>.from(
          (map['points'] as List<String>),
        ));
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
