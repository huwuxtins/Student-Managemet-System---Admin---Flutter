import 'package:admin/model/subject.dart';
import 'package:admin/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shift {
  Subject? subject;
  Teacher? teacher;
  String? lop;

  Shift({required this.subject, required this.teacher, this.lop});

  Shift.fromJson(Map<String, Object?> json)
      : this(
            subject: json['subject'] as Subject,
            teacher: json['teacher'] as Teacher);

  factory Shift.fromFirestore(
      DocumentSnapshot<Object?> snapshot, Teacher? teacher, Subject subject) {
    final data = snapshot.data() as Map<String, Object?>;
    return Shift(
      subject: subject,
      teacher: teacher,
      lop: data['lop'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'subject': subject!.id,
      'teacher': (teacher != null) ? teacher!.id : null,
      'lop': lop,
    };
  }
}
