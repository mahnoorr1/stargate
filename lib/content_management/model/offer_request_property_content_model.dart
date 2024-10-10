// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OfferRequestPropertyContentModel {
  final String title;
  final String offerSelectionTagLine;
  final String conditionTagLine;
  final String investmentTypeTagLine;
  OfferRequestPropertyContentModel({
    required this.title,
    required this.offerSelectionTagLine,
    required this.conditionTagLine,
    required this.investmentTypeTagLine,
  });

  OfferRequestPropertyContentModel copyWith({
    String? title,
    String? offerSelectionTagLine,
    String? conditionTagLine,
    String? investmentTypeTagLine,
  }) {
    return OfferRequestPropertyContentModel(
      title: title ?? this.title,
      offerSelectionTagLine:
          offerSelectionTagLine ?? this.offerSelectionTagLine,
      conditionTagLine: conditionTagLine ?? this.conditionTagLine,
      investmentTypeTagLine:
          investmentTypeTagLine ?? this.investmentTypeTagLine,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'offerSelectionTagLine': offerSelectionTagLine,
      'conditionTagLine': conditionTagLine,
      'investmentTypeTagLine': investmentTypeTagLine,
    };
  }

  factory OfferRequestPropertyContentModel.fromMap(Map<String, dynamic> map) {
    return OfferRequestPropertyContentModel(
      title: map['title'] ?? "",
      offerSelectionTagLine: map['offerSelectionTagLine'] ?? "",
      conditionTagLine: map['conditionTagLine'] ?? "",
      investmentTypeTagLine: map['investmentTypeTagLine'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferRequestPropertyContentModel.fromJson(String source) =>
      OfferRequestPropertyContentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OfferRequestPropertyContentModel(title: $title, offerSelectionTagLine: $offerSelectionTagLine, conditionTagLine: $conditionTagLine, investmentTypeTagLine: $investmentTypeTagLine)';
  }

  @override
  bool operator ==(covariant OfferRequestPropertyContentModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.offerSelectionTagLine == offerSelectionTagLine &&
        other.conditionTagLine == conditionTagLine &&
        other.investmentTypeTagLine == investmentTypeTagLine;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        offerSelectionTagLine.hashCode ^
        conditionTagLine.hashCode ^
        investmentTypeTagLine.hashCode;
  }
}
