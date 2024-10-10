// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProfileContentModel {
  final String profileIcon;
  final String passwordIcon;
  final String emailIcon;
  final String occupationSelectionTagLine;
  final String specializationTagLine;
  final String investmentTagLine;
  final String investmentCategoryTagLine;
  final String referencesTagLine;
  ProfileContentModel({
    required this.profileIcon,
    required this.passwordIcon,
    required this.emailIcon,
    required this.occupationSelectionTagLine,
    required this.specializationTagLine,
    required this.investmentTagLine,
    required this.investmentCategoryTagLine,
    required this.referencesTagLine,
  });

  ProfileContentModel copyWith({
    String? profileIcon,
    String? passwordIcon,
    String? emailIcon,
    String? occupationSelectionTagLine,
    String? specializationTagLine,
    String? investmentTagLine,
    String? investmentCategoryTagLine,
    String? referencesTagLine,
  }) {
    return ProfileContentModel(
      profileIcon: profileIcon ?? this.profileIcon,
      passwordIcon: passwordIcon ?? this.passwordIcon,
      emailIcon: emailIcon ?? this.emailIcon,
      occupationSelectionTagLine:
          occupationSelectionTagLine ?? this.occupationSelectionTagLine,
      specializationTagLine:
          specializationTagLine ?? this.specializationTagLine,
      investmentTagLine: investmentTagLine ?? this.investmentTagLine,
      investmentCategoryTagLine:
          investmentCategoryTagLine ?? this.investmentCategoryTagLine,
      referencesTagLine: referencesTagLine ?? this.referencesTagLine,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileIcon': profileIcon,
      'passwordIcon': passwordIcon,
      'emailIcon': emailIcon,
      'occupationSelectionTagLine': occupationSelectionTagLine,
      'specializationTagLine': specializationTagLine,
      'investmentTagLine': investmentTagLine,
      'investmentCategoryTagLine': investmentCategoryTagLine,
      'referencesTagLine': referencesTagLine,
    };
  }

  factory ProfileContentModel.fromMap(Map<String, dynamic> map) {
    return ProfileContentModel(
      profileIcon: map['profileIcon'] ?? "",
      passwordIcon: map['passwordIcon'] ?? "",
      emailIcon: map['emailIcon'] ?? "",
      occupationSelectionTagLine: map['occupationSelectionTagLine'] ?? "",
      specializationTagLine: map['specializationTagLine'] ?? "",
      investmentTagLine: map['investmentTagLine'] ?? "",
      investmentCategoryTagLine: map['investmentCategoryTagLine'] ?? "",
      referencesTagLine: map['referencesTagLine'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileContentModel.fromJson(String source) =>
      ProfileContentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileContentModel(profileIcon: $profileIcon, passwordIcon: $passwordIcon, emailIcon: $emailIcon, occupationSelectionTagLine: $occupationSelectionTagLine, specializationTagLine: $specializationTagLine, investmentTagLine: $investmentTagLine, investmentCategoryTagLine: $investmentCategoryTagLine, referencesTagLine: $referencesTagLine)';
  }

  @override
  bool operator ==(covariant ProfileContentModel other) {
    if (identical(this, other)) return true;

    return other.profileIcon == profileIcon &&
        other.passwordIcon == passwordIcon &&
        other.emailIcon == emailIcon &&
        other.occupationSelectionTagLine == occupationSelectionTagLine &&
        other.specializationTagLine == specializationTagLine &&
        other.investmentTagLine == investmentTagLine &&
        other.investmentCategoryTagLine == investmentCategoryTagLine &&
        other.referencesTagLine == referencesTagLine;
  }

  @override
  int get hashCode {
    return profileIcon.hashCode ^
        passwordIcon.hashCode ^
        emailIcon.hashCode ^
        occupationSelectionTagLine.hashCode ^
        specializationTagLine.hashCode ^
        investmentTagLine.hashCode ^
        investmentCategoryTagLine.hashCode ^
        referencesTagLine.hashCode;
  }
}
