import 'dart:html' as html;
import 'package:admin/data/student.dart';
import 'package:admin/data/teacher.dart';
import 'package:admin/model/student.dart';
import 'package:admin/model/teacher.dart';
import 'package:admin/model/user.dart';
import 'package:admin/page/change_user.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTable extends StatefulWidget {
  UserTable({key, required this.titles, required this.users, this.className})
      : super(key: key);

  final List<String> titles;
  final List<UserCustom> users;
  String? className;

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  late List<String> _titles;
  late List<UserCustom> _users;
  String? _className;
  List<UserCustom> selectedUsers = [];
  List<List<dynamic>> _excelData = [];
  bool isAdding = false;

  @override
  void initState() {
    super.initState();
    _titles = widget.titles;
    _users = widget.users;
    _className = widget.className;
  }

  List<List<dynamic>> _readExcelData(List<int> data) {
    final excel = Excel.decodeBytes(data);
    final sheet = excel.tables.keys.first;
    return excel.tables[sheet]!.rows;
  }

  List<Student> convertToMap(List<List<dynamic>> excelData) {
    List<Student> resultMap = [];

    for (int i = 0; i < excelData.length; i++) {
      List<dynamic> row = excelData[i];

      Student rowData = Student(
          id: row[0].toString().split("(")[1].split(",")[0],
          name: row[1].toString().split("(")[1].split(",")[0],
          gender: row[2].toString().split("(")[1].split(",")[0],
          dob: DateTime.parse(row[3].toString().split("(")[1].split(",")[0]),
          email: row[4].toString().split("(")[1].split(",")[0],
          password: "student-password-12398765",
          phoneNumber: row[5].toString().split("(")[1].split(",")[0],
          address: row[6].toString().split("(")[1].split(",")[0]);

      resultMap.add(rowData);
    }

    return resultMap;
  }

  Future<void> exportToExcel(List<UserCustom> users) async {
    Excel excel = Excel.createExcel();

    // Add a sheet to the Excel file
    Sheet sheetObject = excel['Sheet1'];

    // Add data to the sheet
    for (var user in users) {
      sheetObject.appendRow([
        TextCellValue(user.id),
        TextCellValue(user.name),
        TextCellValue(user.gender),
        TextCellValue("${user.dob}"),
        TextCellValue(user.email),
        TextCellValue(user.password),
        TextCellValue(user.phoneNumber),
        TextCellValue(user.address),
      ]);
    }

    excel.save(fileName: "User.xlsx");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SearchAnchor(
                viewShape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                builder: (context, controller) {
                  return SearchBar(
                    hintText: "Enter student's name",
                    controller: controller,
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (value) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    surfaceTintColor: MaterialStateProperty.all(Colors.white),
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: (selectedUsers.isNotEmpty)
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: (selectedUsers.length == 1)
                  ? ElevatedButton(
                      onPressed: () async {
                        UserCustom changedUser = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeUser(
                                    user: selectedUsers[0], users: _users)));
                        setState(() {
                          _users[_users.indexWhere(
                              (u) => u.id == changedUser.id)] = changedUser;
                          if (changedUser is Student) {
                            addStudent(changedUser, _className!);
                          }
                        });
                        selectedUsers = [];
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: ElevatedButton(
                onPressed: () async {
                  UserCustom? changedUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeUser(users: _users)));
                  if (changedUser != null) {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: changedUser.email,
                            password: changedUser.password);

                    changedUser.id = userCredential.user!.uid;

                    setState(() {
                      _users.add(changedUser);
                      if (changedUser is Student) {
                        addStudent(changedUser, _className!);
                      } else if (changedUser is Teacher) {
                        addTeacher(changedUser);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        DataTable(
          columns: _titles.map((title) {
            return DataColumn(
              label: Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            );
          }).toList(),
          rows: _users.map((user) {
            return DataRow(
                selected: selectedUsers.contains(user),
                onSelectChanged: (value) {
                  setState(() {
                    if (selectedUsers.contains(user)) {
                      selectedUsers.remove(user);
                    } else {
                      selectedUsers.add(user);
                    }
                  });
                },
                cells: <DataCell>[
                  DataCell(Text(user.id)),
                  DataCell(Text(user.name), onTap: () {}),
                  DataCell(Text(user.gender)),
                  DataCell(Text("${user.dob}")),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.phoneNumber)),
                  DataCell(Text(user.address)),
                ]);
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: GestureDetector(
                  onTap: () {
                    if (kIsWeb) {
                      html.FileUploadInputElement uploadInput =
                          html.FileUploadInputElement();
                      uploadInput.multiple = false;
                      uploadInput.accept = '.xlsx'; // Limit file type to xlsx
                      uploadInput.click();

                      uploadInput.onChange.listen((e) {
                        final files = uploadInput.files;
                        if (files != null && files.isNotEmpty) {
                          final file = files[0];
                          final reader = html.FileReader();
                          reader.readAsArrayBuffer(file);
                          reader.onLoadEnd.listen((event) {
                            setState(() {
                              isAdding = !isAdding;
                              _excelData =
                                  _readExcelData(reader.result as List<int>);
                              _users = convertToMap(_excelData);
                            });
                          });
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Import from Excel file",
                    style: TextStyle(color: Colors.blue),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: (isAdding == true)
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAdding = !isAdding;
                          for (var element in _users) {
                            if (element is Student) {
                              addStudent(element, _className!);
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: ElevatedButton(
                  onPressed: () {
                    exportToExcel(_users);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Export to Excel file",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
