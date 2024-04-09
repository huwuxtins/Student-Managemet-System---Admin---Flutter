import 'package:admin/model/class.dart';
import 'package:admin/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher extends UserCustom {
  String role = "TEACHER";
  int salary;
  String mainMajor;
  DateTime startDate;
  List<Class>? classes;

  Teacher(
      {required super.id,
      required super.name,
      required super.dob,
      required super.gender,
      required super.email,
      required super.password,
      required super.phoneNumber,
      required super.address,
      required this.mainMajor,
      required this.salary,
      required this.startDate,
      required this.classes});

  factory Teacher.fromJson(QueryDocumentSnapshot<Object?> json, List<Class>? lop) {
    final data = json.data() as Map<String, Object?>;
    return Teacher(
        id: data['id'] as String,
        name: data['name'] as String,
        dob: _convertTimestamp(json['dob'] as Timestamp),
        gender: data['gender'] as String,
        email: data['email'] as String,
        password: data['password'] as String,
        phoneNumber: data['phoneNumber'] as String,
        address: data['address'] as String,
        mainMajor: data['mainMajor'] as String,
        salary: data['salary'] as int,
        startDate: _convertTimestamp(json['startDate'] as Timestamp),
        classes: lop?? []);
  }

  factory Teacher.fromJsonDoc(DocumentSnapshot json, List<Class> classes) {
    final data = json.data()! as Map<String, Object?>;
    return Teacher(
        id: data['id'] as String,
        name: data['name'] as String,
        dob: _convertTimestamp(json['dob'] as Timestamp),
        gender: data['gender'] as String,
        email: data['email'] as String,
        password: data['password'] as String,
        phoneNumber: data['phoneNumber'] as String,
        address: data['address'] as String,
        mainMajor: data['mainMajor'] as String,
        salary: data['salary'] as int,
        startDate: _convertTimestamp(json['startDate'] as Timestamp),
        classes: classes);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'gender': gender,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
      'mainMajor': mainMajor,
      'salary': salary,
      'startDate': startDate,
      'classes': classes,
    };
  }
    
  static DateTime _convertTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
