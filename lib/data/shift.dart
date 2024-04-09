import 'package:admin/data/subject.dart';
import 'package:admin/data/teacher.dart';
import 'package:admin/model/shift.dart';
import 'package:admin/model/subject.dart';
import 'package:admin/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Future<Map<String, Map<int, List<Shift>>>> getTimeTables(
    List<String> classNames) async {
  Map<String, Map<int, List<Shift>>> timeTables = {};

  List<Map<int, List<Shift>>?> listTimeTable = await Future.wait(
      classNames.map((className) => getTimeTableByClass(className)));

  for (int i = 0; i < classNames.length; i++) {
    timeTables.addAll({classNames[i]: listTimeTable[i]!});
  }

  return timeTables;
}

Future<Map<int, List<Shift>>?> getTimeTableByClass(String className) async {
  Map<int, List<Shift>> timeTable = {
    1: [
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
    ],
    2: [
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
    ],
    3: [
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
    ],
    4: [
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
    ],
    5: [
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
      Shift(subject: null, teacher: null),
    ]
  };

  DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
      .collection('time_table')
      .doc(className)
      .get();

  for (int period = 1; period <= 5; period++) {
    Map<String, Object?> shiftIds = {};
    try {
      shiftIds = doc.get(period.toString()) as Map<String, Object?>;

      List<Shift> shifts = [
        Shift(subject: null, teacher: null),
        Shift(subject: null, teacher: null),
        Shift(subject: null, teacher: null),
        Shift(subject: null, teacher: null),
        Shift(subject: null, teacher: null),
        Shift(subject: null, teacher: null),
      ];

      for (var entry in shiftIds.entries) {
        String key = entry.key;
        String shiftId = entry.value as String;

        DocumentSnapshot<Map<String, dynamic>> shiftDoc =
            await FirebaseFirestore.instance
                .collection("shifts")
                .doc(shiftId)
                .get();
        Future<Shift> shiftFuture = Future.wait([
          getTeacherById((shiftDoc.data()!['teacher'] != null)
              ? shiftDoc.data()!['teacher']
              : "teacher"),
          getSubjectById(shiftDoc.data()!['subject']),
        ]).then((List<dynamic> results) {
          Teacher? teacher = results[0] as Teacher?;
          Subject? subject = results[1] as Subject?;

          if (subject != null) {
            return Shift.fromFirestore(shiftDoc, teacher, subject);
          } else {
            throw Exception('Failed to fetch teacher or subject');
          }
        });

        Shift shift = await shiftFuture;
        switch (key) {
          case "mon":
            shifts[0] = shift;
            break;
          case "tus":
            shifts[1] = shift;
            break;
          case "wed":
            shifts[2] = shift;
            break;
          case "thu":
            shifts[3] = shift;
            break;
          case "fri":
            shifts[4] = shift;
            break;
          case "sat":
            shifts[5] = shift;
            break;
        }
      }

      // Add the list of shifts for the current period to the timeTable map
      timeTable[period] = shifts;
    } catch (e) {
      print(e);
    }
  }
  return timeTable;
}

// Future

Future<void> addTimeTableByClass(
    String className, Map<int, List<Shift>> timeTable) async {
  var db = FirebaseFirestore.instance;

  Map<String, Map<String, String>> data = {};

  for (var element in timeTable.entries) {
    Map<String, String> listShiftId = {};

    for (int i = 0; i < 6; i++) {
      String shiftId = const Uuid().v4();
      if (element.value[i].subject != null && element.value[i].lop != null) {
        await db
            .collection("shifts")
            .doc(shiftId)
            .set(element.value[i].toJson())
            .then((value) {
          String day = "";
          switch (i) {
            case 0:
              day = "mon";
              break;
            case 1:
              day = "tus";
              break;
            case 2:
              day = "wed";
              break;
            case 3:
              day = "thu";
              break;
            case 4:
              day = "fri";
              break;
            case 5:
              day = "sat";
              break;
          }
          listShiftId.addAll({day: shiftId});
        });
      }
    }

    data.addAll({element.key.toString(): listShiftId});
  }

  await db
      .collection("time_table")
      .doc(className)
      .set(data)
      .onError((error, stackTrace) => print("Error: $error"));
}

Future<void> updateShift(String className, String teacherId) async {
  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection("shifts")
      .where("lop", isEqualTo: className)
      .get();

  for (var doc in query.docs) {
    String shiftId = doc.id;

    await FirebaseFirestore.instance
        .collection("shifts")
        .doc(shiftId)
        .update({"teacher": teacherId});
  }
}
