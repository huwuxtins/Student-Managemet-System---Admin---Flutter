import 'package:admin/data/classes.dart';
import 'package:admin/data/department.dart';
import 'package:admin/model/class.dart';
import 'package:admin/model/department.dart';
import 'package:admin/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<Map<String, List<Teacher>?>> getTeacherByDepartment() async {
  Map<String, List<Teacher>> listTeacher = {};
  List<Department> departments = [];
  await getAllDepartment().then((value) {
    return departments = value!;
  });

  try {
    QuerySnapshot<Map<String, dynamic>> query =
        await FirebaseFirestore.instance.collection("teachers").get();

    for (var department in departments) {
      List<Teacher> teachers = [];
      for (var element in query.docs) {
        
        final List<dynamic>? claseesData =
            element.data()['classes'] as List<dynamic>?;

        List<Class> classes = await Future.wait(
            claseesData!.map((element) => getClassById(element)));

        Teacher teacher = Teacher.fromJson(element, classes);

        if (teacher.mainMajor == department.name) {
          teachers.add(teacher);
        }
      }
      listTeacher.addAll({department.name: teachers});
    }
  } catch (e) {
    print('Error retrieving data from Firestore: $e');
  }
  return listTeacher;
}

Future<Teacher?> getTeacherById(String id) async {
  DocumentSnapshot query =
      await FirebaseFirestore.instance.collection("teachers").doc(id).get();

  if (query.data() == null) {
    return null;
  }

  return Teacher.fromJsonDoc(query, []);
}

Future<void> updateClassesTeacher(String teacherId, String className) async {
  
  await FirebaseFirestore.instance
      .collection("teachers")
      .doc(teacherId)
      .update({"classes": FieldValue.arrayUnion([className])});
}

Future<void> addTeacher(Teacher teacher) async {
  var db = FirebaseFirestore.instance;
  await db
      .collection("teachers")
      .doc(teacher.id)
      .set(teacher.toJson())
      .onError((error, stackTrace) => print(error));
}

