import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationApp {
  final String id;
  final String title;
  final String type;
  final String content;
  final String linkPDF;
  final DateTime createdAt;

  NotificationApp(
      {required this.id,
      required this.title,
      required this.type,
      required this.content,
      required this.linkPDF,
      required this.createdAt});

  factory NotificationApp.fromFirebase(
      DocumentSnapshot<Map<String, dynamic>> query) {
    final data = query.data()!;
    return NotificationApp(
        id: data['id'] as String,
        title: data['title'] as String,
        type: data['type'] as String,
        content: data['content'] as String,
        linkPDF: data['linkPDF'] as String,
        createdAt: _convertTimestamp(data['createdAt'] as Timestamp));
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'content': content,
      'linkPDF': linkPDF,
      'createdAt': createdAt
    };
  }

  static DateTime _convertTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
