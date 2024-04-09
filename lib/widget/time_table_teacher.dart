import 'dart:collection';
import 'dart:html' as html;
import 'package:admin/data/classes.dart';
import 'package:admin/data/shift.dart';
import 'package:admin/data/teacher.dart';
import 'package:admin/model/class.dart';
import 'package:admin/model/teacher.dart';
import 'package:excel/excel.dart';
import 'package:admin/model/shift.dart';
import 'package:admin/widget/shift_item.dart';
import 'package:flutter/material.dart';

class TimeTableTeacher extends StatefulWidget {
  const TimeTableTeacher(
      {key,
      required this.timeTableAll,
      required this.shifts,
      required this.onChange,
      required this.teacher})
      : super(key: key);

  final Map<String, Map<int, List<Shift>>> timeTableAll;
  final Map<int, List<Shift>> shifts;
  final Function onChange;
  final Teacher teacher;

  @override
  State<TimeTableTeacher> createState() => _TimeTableTeacherState();
}

class _TimeTableTeacherState extends State<TimeTableTeacher> {
  Map<String, Map<int, List<Shift>>> _timeTableAll = {};
  late Map<int, List<Shift>> _shifts;
  late Function _onChange;
  late Teacher _teacher;
  HashSet<Class> classSelected = HashSet();

  bool isEditing = false;

  Map<int, List<Shift>> excelShift = {};

  @override
  void initState() {
    super.initState();
    _shifts = widget.shifts;
    _onChange = widget.onChange;
    _teacher = widget.teacher;
    _timeTableAll = widget.timeTableAll;
    if (_teacher.classes != null) {
      for (var element in _teacher.classes!) {
        _shifts = combine(_shifts, element.name, _teacher.mainMajor);
        classSelected.add(element);
      }
    }
  }

  List<List<dynamic>> _readExcelData(List<int> data) {
    final excel = Excel.decodeBytes(data);
    final sheet = excel.tables.keys.first;
    return excel.tables[sheet]!.rows;
  }

  Future<void> exportToExcel(Map<int, List<Shift>> shifts) async {
    Excel excel = Excel.createExcel();

    // Add a sheet to the Excel file
    Sheet sheetObject = excel['Sheet1'];

    // Add data to the sheet
    shifts.forEach((key, value) {
      sheetObject.appendRow(value.map((e) {
        return TextCellValue((e.subject != null) ? e.subject!.name : "");
      }).toList());
    });

    excel.save(fileName: "TimeTableTeacher.xlsx");
  }

  Future<List<DropdownMenuItem<Class>>> getClassDropdownItems() async {
    List<DropdownMenuItem<Class>> items = [];
    Map<int, List<Class>>? classes = await getClasses();
    classes!.forEach((grade, gradeClasses) {
      for (var classItem in gradeClasses) {
        items.add(
          DropdownMenuItem(
            value: classItem,
            child: Text(classItem.name),
          ),
        );
      }
    });
    return items;
  }

  Map<int, List<Shift>> combine(
      Map<int, List<Shift>> teacher, String LOP, String subject) {
    _timeTableAll[LOP]!.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        if (_timeTableAll[LOP]![key]![i].subject != null) {
          if (_timeTableAll[LOP]![key]![i].subject!.name == subject && _timeTableAll[LOP]![key]![i].teacher == null) {
            
            teacher[key]![i].subject = _timeTableAll[LOP]![key]![i].subject;
            teacher[key]![i].lop = LOP;
          }
        }
      }
    });
    return teacher;
  }

  String getNameClasses(HashSet<Class> classes) {
    String result = "";
    for (var element in classes) {
      result = "$result ${element.name}";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: Text("Classes: ${getNameClasses(classSelected)}"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: (isEditing)
                    ? FutureBuilder<List<DropdownMenuItem<Class>>>(
                        future: getClassDropdownItems(),
                        builder: (context, snapshot) {
                          return DropdownButton(
                            items: snapshot.data,
                            onChanged: (value) {
                              if (_onChange(value!.name)) {
                                setState(() {
                                  classSelected.add(value);
                                  _shifts = combine(
                                      _shifts, value.name, _teacher.mainMajor);
                                });
                              }
                            },
                          );
                        },
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isEditing == true) {
                          for (var className in classSelected) {
                            updateShift(className.name, _teacher.id);
                            updateClassesTeacher(_teacher.id, className.name);
                          }
                        }
                        isEditing = !isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      isEditing ? "Save" : "Edit",
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: (isEditing)
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ))
                    : null,
              ),
            ],
          ),
          Table(
            border: TableBorder.all(borderRadius: BorderRadius.circular(5.0)),
            columnWidths: const <int, TableColumnWidth>{},
            children: List.from([
              const TableRow(children: [
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(""),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Mon"),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Tus"),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("WED"),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("THUS"),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("FRI"),
                )),
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("SAT"),
                ))
              ])
            ])
              ..addAll(_shifts.keys.map((position) {
                return TableRow(
                    children: List.from([
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Shift: $position"),
                    ),
                  )
                ])
                      ..addAll(_shifts[position]!.map((shift) {
                        if (shift.subject != null) {
                          return ShiftItem(
                            shift: shift,
                            lop: shift.lop!,
                          );
                        }
                        return const Center(
                          child: Text("Empty"),
                        );
                      }).toList()));
              }).toList()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: (!isEditing)
                    ? ElevatedButton(
                        onPressed: () {
                          exportToExcel(_shifts);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "Export to Excel file",
                          style: TextStyle(color: Colors.white),
                        ))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
