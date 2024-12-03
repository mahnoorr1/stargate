// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  final String id;
  final String sender;
  final String recipient;
  final String title;
  final String message;
  final String profileImage;
  final String date;
  final String time;
  final bool read;
  NotificationModel({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.title,
    required this.message,
    required this.profileImage,
    required this.date,
    required this.time,
    required this.read,
  });

  NotificationModel copyWith({
    String? id,
    String? sender,
    String? recipient,
    String? title,
    String? message,
    String? profileImage,
    String? date,
    String? time,
    bool? read,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      title: title ?? this.title,
      message: message ?? this.message,
      profileImage: profileImage ?? this.profileImage,
      date: date ?? this.date,
      time: time ?? this.time,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sender': sender,
      'recipient': recipient,
      'title': title,
      'message': message,
      'profileImage': profileImage,
      'date': date,
      'time': time,
      'read': read,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
        id: map['id'] ?? '',
        sender: map['sender'] ?? '',
        recipient: map['recipient'] ?? '',
        title: map['title'] ?? '',
        message: map['message'] ?? '',
        profileImage: map['profileImage'] ?? '',
        date: map['date'] ?? '',
        time: map['time'] ?? '',
        read: map['read'] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(id: $id, sender: $sender, recipient: $recipient, title: $title, message: $message, profileImage: $profileImage, date: $date, time: $time, read: $read)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sender == sender &&
        other.recipient == recipient &&
        other.title == title &&
        other.message == message &&
        other.profileImage == profileImage &&
        other.date == date &&
        other.time == time &&
        other.read == read;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        recipient.hashCode ^
        title.hashCode ^
        message.hashCode ^
        profileImage.hashCode ^
        date.hashCode ^
        time.hashCode ^
        read.hashCode;
  }
}
