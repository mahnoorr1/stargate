// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GettingStartedModel {
  final String id;
  final String page;
  final String title;
  final String content;
  final String picture;
  GettingStartedModel({
    required this.id,
    required this.page,
    required this.title,
    required this.content,
    required this.picture,
  });

  GettingStartedModel copyWith({
    String? id,
    String? page,
    String? title,
    String? content,
    String? picture,
  }) {
    return GettingStartedModel(
      id: id ?? this.id,
      page: page ?? this.page,
      title: title ?? this.title,
      content: content ?? this.content,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'page': page,
      'title': title,
      'content': content,
      'picture': picture,
    };
  }

  factory GettingStartedModel.fromMap(Map<String, dynamic> map) {
    return GettingStartedModel(
      id: map['_id'] ?? "",
      page: map['page'] ?? "",
      title: map['title'] ?? "",
      content: map['content'] ?? "",
      picture: map['picture'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory GettingStartedModel.fromJson(String source) =>
      GettingStartedModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GettingStartedModel(_id: $id, page: $page, title: $title, content: $content, picture: $picture)';
  }

  @override
  bool operator ==(covariant GettingStartedModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.page == page &&
        other.title == title &&
        other.content == content &&
        other.picture == picture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        page.hashCode ^
        title.hashCode ^
        content.hashCode ^
        picture.hashCode;
  }
}
