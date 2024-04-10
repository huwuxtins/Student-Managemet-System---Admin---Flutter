import 'package:admin/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// List<Student> students = [
//   Student("student1", "Nguyen Van A", DateTime(2003, 12, 24), "Male", "nguyenvana@gmail.com",
//       "5634785", "0923644657", "Nguyen Huu Tho"),
//   Student("student2", "Nguyen Thi B", DateTime(2003, 12, 24), "Male", "nguyenthib@gmail.com",
//       "56dgsdf785", "09235674557", "Nguyen Huu Tho"),
//   Student("student3", "Nguyen Van C", DateTime(2003, 12, 24), "Male", "nguyenvana@gmail.com",
//       "hfghd5645", "09235665757", "Nguyen Huu Tho"),
//   Student("student4", "Nguyen Van D", DateTime(2003, 12, 24), "Male", "nguyenvana@gmail.com",
//       "dfhdhfgh", "0964576457", "Nguyen Huu Tho"),
//   Student("student5", "Tran Van L", DateTime(2003, 12, 24), "Male", "nguyenvana@gmail.com",
//       "867864", "09236456456", "Nguyen Huu Tho"),
// ];

Future<void> addStudent(Student student, String className) async {
  var db = FirebaseFirestore.instance;
  await db
      .collection("students")
      .doc(student.id)
      .set(student.toJson())
      .onError((error, stackTrace) => print(error));

  await db.collection("classes").doc(className).update({
    "students": FieldValue.arrayUnion([student.id])
  });
}

Future<void> deleteStudent(Student student) async {
  await FirebaseFirestore.instance
      .collection("students")
      .doc(student.id)
      .delete();
}
