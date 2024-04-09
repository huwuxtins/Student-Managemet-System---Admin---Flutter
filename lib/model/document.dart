import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  String id;
  String name;
  String linkPDF;
  DateTime createdAt;

  Document(
      {required this.id,
      required this.name,
      required this.linkPDF,
      required this.createdAt});

  factory Document.fromFirebase(DocumentSnapshot<Map<String, dynamic>> query) {
    final data = query.data()!;

    return Document(
        id: data['id'] as String,
        name: data['name']! as String,
        linkPDF: data['id'] as String,
        createdAt: _convertTimestamp(data['createdAt'] as Timestamp));
  }

  Map<String, Object?> toJson() {
    return {"id": id, "name": name, "createdAt": createdAt};
  }

  static DateTime _convertTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
