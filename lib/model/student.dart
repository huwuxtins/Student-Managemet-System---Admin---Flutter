import 'package:admin/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Student extends UserCustom {
  String role = "STUDENT";

  Student(
      {required super.id,
      required super.name,
      required super.dob,
      required super.gender,
      required super.email,
      required super.password,
      required super.phoneNumber,
      required super.address});

  Student.fromJson(Map<String, Object?> json)
      : this(
            id: json['id'] as String,
            name: json['name'] as String,
            dob: _convertTimestamp(json['dob'] as Timestamp),
            gender: json['gender'] as String,
            email: json['email'] as String,
            password: json['password'] as String,
            phoneNumber: json['phoneNumber'] as String,
            address: json['address'] as String);

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
    };
  }
  
  static DateTime _convertTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
