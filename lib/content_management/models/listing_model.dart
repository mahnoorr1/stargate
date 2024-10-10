// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListingModel {
  final String icon;
  final String searchFilterTagLine;
  ListingModel({
    required this.icon,
    required this.searchFilterTagLine,
  });

  ListingModel copyWith({
    String? icon,
    String? searchFilterTagLine,
  }) {
    return ListingModel(
      icon: icon ?? this.icon,
      searchFilterTagLine: searchFilterTagLine ?? this.searchFilterTagLine,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon,
      'searchFilterTagLine': searchFilterTagLine,
    };
  }

  factory ListingModel.fromMap(Map<String, dynamic> map) {
    return ListingModel(
      icon: map['icon'] ?? "",
      searchFilterTagLine: map['searchFilterTagLine'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ListingModel.fromJson(String source) =>
      ListingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ListingModel(icon: $icon, searchFilterTagLine: $searchFilterTagLine)';

  @override
  bool operator ==(covariant ListingModel other) {
    if (identical(this, other)) return true;

    return other.icon == icon &&
        other.searchFilterTagLine == searchFilterTagLine;
  }

  @override
  int get hashCode => icon.hashCode ^ searchFilterTagLine.hashCode;
}
