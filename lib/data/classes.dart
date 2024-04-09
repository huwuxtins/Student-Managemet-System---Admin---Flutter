import 'package:admin/model/class.dart';
import 'package:admin/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<int, List<Class>>?> getClasses() async {
  List<String> depart = ["10", "11", "12"];
  Map<int, List<Class>> classFirebase = {};

  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('classes').get();

    for (var element in depart) {
      List<Class> classByDepart = [];
      List<QueryDocumentSnapshot<Object?>> listClass =
          querySnapshot.docs.where((doc) => doc.id.contains(element)).toList();

      for (var elementClass in listClass) {
        final data = elementClass.data() as Map<String, Object?>;

        final List<dynamic>? studentsData = data['students'] as List<dynamic>?;

        List<Student> students = await Future.wait(studentsData!.map((element) => getStudentByRef(element)));

        classByDepart.add(Class.fromFirestore(elementClass, students));
      }
      classFirebase.addAll({int.parse(element): classByDepart});
    }
  } catch (error) {
    print('Error retrieving data from Firestore: $error');
  }
  return classFirebase;
}



Future<Class> getClassById(String id) async {
  
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('classes').doc(id).get();

    final data = querySnapshot.data() as Map<String, Object?>;

      final List<dynamic>? studentsData = data['students'] as List<dynamic>?;

      List<Student> students = await Future.wait(studentsData!.map((element) => getStudentByRef(element)));

    return Class.fromJsonDoc(querySnapshot, students);
}

Future<Student> getStudentByRef(String? ref) async {
  
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('students').doc(ref).get();

    return Student.fromJson(querySnapshot.data() as Map<String, Object?>);
}
