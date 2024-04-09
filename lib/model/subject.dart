import 'package:admin/model/document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  String id;
  String name;
  int level;
  List<Document> documents;

  Subject({required this.id, required this.name, required this.level, required this.documents});

  Subject.fromJson(Map<String, Object?> json, List<Document> docs)
      : this(
            id: json['id'] as String,
            name: json['name'] as String,
            level: json['level'] as int,
            documents: docs);

  factory Subject.fromFirestore(
      QueryDocumentSnapshot<Object?> snapshot, List<Document> docs) {
    final data = snapshot.data()! as Map<String, Object?>;

    return Subject(
      id: data['id'] as String,
        name: data['name'] as String,
        level: data['level'] as int,
        documents: docs);
  }

  factory Subject.fromJsonDoc(
      DocumentSnapshot<Object?> snapshot, List<Document> docs) {
    final data = snapshot.data()! as Map<String, Object?>;
    return Subject(
      id: data['id'] as String,
        name: data['name'] as String,
        level: data['level'] as int,
        documents: docs);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'docs': List<String>.from(documents.map((e) => e.linkPDF)),
    };
  }
}
