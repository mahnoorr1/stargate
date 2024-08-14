import 'dart:convert';

class FAQ {
  String question;
  String? textReply;
  String? videoURL;
  FAQ({
    required this.question,
    this.textReply,
    this.videoURL,
  });

  FAQ copyWith({
    String? question,
    String? textReply,
    String? videoURL,
  }) {
    return FAQ(
      question: question ?? this.question,
      textReply: textReply ?? this.textReply,
      videoURL: videoURL ?? this.videoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'textReply': textReply,
      'videoURL': videoURL,
    };
  }

  factory FAQ.fromMap(Map<String, dynamic> map) {
    return FAQ(
      question: map['question'] as String,
      textReply: map['textReply'] != null ? map['textReply'] as String : null,
      videoURL: map['videoURL'] != null ? map['videoURL'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FAQ.fromJson(String source) =>
      FAQ.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FAQ(question: $question, textReply: $textReply, videoURL: $videoURL)';

  @override
  bool operator ==(covariant FAQ other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        other.textReply == textReply &&
        other.videoURL == videoURL;
  }

  @override
  int get hashCode =>
      question.hashCode ^ textReply.hashCode ^ videoURL.hashCode;
}
