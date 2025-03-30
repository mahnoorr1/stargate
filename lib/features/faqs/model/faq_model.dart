// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FAQ {
  String? id;
  final String question;
  final String answer;
  final String videoURL;

  FAQ({
    this.id,
    required this.question,
    required this.answer,
    required this.videoURL,
  });

  FAQ copyWith({
    String? id,
    String? question,
    String? answer,
    String? videoURL,
  }) {
    return FAQ(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      videoURL: videoURL ?? this.videoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'question': question,
      'answer': answer,
      'video_url': videoURL,
    };
  }

  factory FAQ.fromMap(Map<String, dynamic> map) {
    return FAQ(
      id: map['_id'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      videoURL: map['video_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FAQ.fromJson(String source) =>
      FAQ.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FAQ(_id: $id, question: $question, answer: $answer, video_url: $videoURL)';
  }
}
