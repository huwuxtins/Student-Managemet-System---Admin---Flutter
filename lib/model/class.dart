import 'package:admin/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  final String name;
  final List<Student> students;

  Class({required this.name, required this.students});

  factory Class.fromFirestore(
      QueryDocumentSnapshot<Object?> snapshot, List<Student> students) {
    final data = snapshot.data() as Map<String, Object?>;
    return Class(name: data['name'] as String, students: students);
  }

  factory Class.fromJsonDoc(DocumentSnapshot<Object?> snapshot, List<Student> students){
    final data = snapshot.data() as Map<String, Object?>;
    return Class(name: data['name'] as String, students: students);
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'students': students,
    };
  }

  int extractNumericGrade(String grade) {
    RegExp regex = RegExp(
        r'^(\d+)'); // Match one or more digits at the start of the string
    Match? match = regex.firstMatch(grade);

    if (match != null) {
      String numericPart =
          match.group(1)!; // Get the first capturing group (digits)
      return int.parse(numericPart);
    } else {
      throw FormatException('Invalid grade format');
    }
  }
}
