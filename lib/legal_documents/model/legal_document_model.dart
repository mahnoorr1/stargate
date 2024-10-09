// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LegalDocument {
  final String type;
  final String content;
  final String file;
  LegalDocument({
    required this.type,
    required this.content,
    required this.file,
  });

  LegalDocument copyWith({
    String? type,
    String? content,
    String? file,
  }) {
    return LegalDocument(
      type: type ?? this.type,
      content: content ?? this.content,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'content': content,
      'file': file,
    };
  }

  factory LegalDocument.fromMap(Map<String, dynamic> map) {
    return LegalDocument(
      type: map['type'] ?? "",
      content: map['content'] ?? "",
      file: map['file'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory LegalDocument.fromJson(String source) =>
      LegalDocument.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LegalDocument(type: $type, content: $content, file: $file)';

  @override
  bool operator ==(covariant LegalDocument other) {
    if (identical(this, other)) return true;

    return other.type == type && other.content == content && other.file == file;
  }

  @override
  int get hashCode => type.hashCode ^ content.hashCode ^ file.hashCode;
}
