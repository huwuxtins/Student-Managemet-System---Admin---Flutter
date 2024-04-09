import 'package:admin/model/department.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Department>?> getAllDepartment() async {
  List<Department> departments = [];
  try {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection("departments").get();

    query.docs.forEach((element) {
      departments.add(Department.fromFirestore(element));
    });
  } catch (e) {}
  return departments;
}