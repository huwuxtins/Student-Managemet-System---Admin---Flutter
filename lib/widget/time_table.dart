import 'dart:collection';
import 'dart:html' as html;
import 'package:admin/data/shift.dart';
import 'package:admin/data/subject.dart';
import 'package:admin/model/class.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:admin/model/shift.dart';
import 'package:admin/model/subject.dart';
import 'package:admin/widget/shift_item.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({key, required this.shifts, required this.lop})
      : super(key: key);

  final Map<int, List<Shift>> shifts;
  final Class lop;

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  late Map<int, List<Shift>> _shifts;
  late Class _lop;
  late List<Subject> subjects;

  bool isEditing = false;
  bool isAdding = false;
  List<List<dynamic>> _excelData = [];

  Map<int, List<Shift>> excelShift = {};

  @override
  void initState() {
    super.initState();
    _shifts = widget.shifts;
    _lop = widget.lop;
    getAllSubject().then((value) => subjects = value!);
  }

  List<List<dynamic>> _readExcelData(List<int> data) {
    final excel = Excel.decodeBytes(data);
    final sheet = excel.tables.keys.first;
    return excel.tables[sheet]!.rows;
  }

  Subject? findSubjectByName(String subjectName) {
    for (var s in subjects) {
      if (s.name.toLowerCase().trim() == subjectName.toLowerCase().trim() &&
          s.level == _lop.extractNumericGrade(_lop.name)) {
        return s;
      }
    }
    return null;
  }

  HashSet<String> listDepartment(List<Subject> subjects) {
    HashSet<String> departments = HashSet<String>();
    for (var element in subjects) {
      departments.add(element.name);
    }
    return departments;
  }

  Map<int, List<Shift>> convertToMap(List<List<dynamic>> excelData) {
    Map<int, List<Shift>> resultMap = {};

    for (int i = 0; i < excelData.length; i++) {
      List<dynamic> row = excelData[i];
      List<Shift> rowData = [];

      for (int j = 0; j < row.length; j++) {
        rowData.add(Shift(
          lop: _lop.name,
            subject: (row[j] != null &&
                    row[j].toString().split("(")[1].split(',')[0].isNotEmpty)
                ? findSubjectByName(
                    row[j].toString().split("(")[1].split(",")[0])!
                : null,
            teacher: null));
      }

      resultMap[i + 1] = rowData;
    }

    return resultMap;
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

    excel.save(fileName: "TimeTable.xlsx");
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
                child: (isEditing)
                    ? GestureDetector(
                        onTap: () {
                          if (kIsWeb) {
                            html.FileUploadInputElement uploadInput =
                                html.FileUploadInputElement();
                            uploadInput.multiple = false;
                            uploadInput.accept =
                                '.xlsx'; // Limit file type to xlsx
                            uploadInput.click();

                            uploadInput.onChange.listen((e) {
                              final files = uploadInput.files;
                              if (files != null && files.isNotEmpty) {
                                final file = files[0];
                                final reader = html.FileReader();
                                reader.readAsArrayBuffer(file);
                                reader.onLoadEnd.listen((event) {
                                  setState(() {
                                    _excelData = _readExcelData(
                                        reader.result as List<int>);
                                    _shifts = convertToMap(_excelData);
                                  });
                                });
                              }
                            });
                          }
                        },
                        child: const Text(
                          "Import from Excel file",
                          style: TextStyle(color: Colors.blue),
                        ))
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isEditing == true) {
                          addTimeTableByClass(_lop.name, _shifts);
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
                          return Stack(children: [
                            ShiftItem(
                              shift: shift,
                            ),
                            Center(
                              child: (isEditing)
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          shift.subject = null;
                                        });
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    )
                                  : null,
                            ),
                          ]);
                        }
                        return Center(
                          child: (isEditing)
                              ? FutureBuilder<List<Subject>?>(
                                  initialData: const [],
                                  future: getAllSubject(),
                                  builder: (context, snapshot) {
                                    return DropdownButton(
                                      items: listDepartment(snapshot.data!)
                                          .map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            shift.lop = _lop.name;
                                            shift.subject =
                                                findSubjectByName(value);
                                          });
                                        }
                                      },
                                    );
                                  },
                                )
                              : const Text("Empty"),
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
