import 'package:cloud_firestore/cloud_firestore.dart';

class Department {
  final String name;

  Department({required this.name});

  factory Department.fromFirestore(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data()! as Map<String, Object?>;
    return Department(name: data['name'] as String);
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
    };
  }
}
