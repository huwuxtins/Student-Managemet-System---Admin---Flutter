import 'package:admin/data/shift.dart';
import 'package:admin/model/class.dart';
import 'package:admin/model/shift.dart';
import 'package:admin/model/student.dart';
import 'package:admin/widget/custom_drawer.dart';
import 'package:admin/widget/class_item.dart';
import 'package:admin/widget/time_table.dart';
import 'package:admin/widget/user_table.dart';
import 'package:flutter/material.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({key, required this.lop}) : super(key: key);

  final Class lop;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  late Class _lop;
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _lop = widget.lop;
    for (var element in _lop.students) {
      students.add(element);
    }
  }

  Widget? main;

  void selectPage(Widget page) {
    setState(() {
      main = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        title: const Text(
          "Add User",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(
        selectPage: selectPage,
      ),
      body: (main == null)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ClassItem(
                      lop: _lop,
                    ),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                child: const Text(
                                  "TimeTable",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    "Students",
                                    style: TextStyle(fontSize: 20),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 2000,
                            child: TabBarView(children: [
                              FutureBuilder<Map<int, List<Shift>>?>(
                                initialData: {
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
                                },
                                future: getTimeTableByClass(_lop.name),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong");
                                  }

                                  if (!snapshot.hasData &&
                                      snapshot.data!.isEmpty) {
                                    return const Text(
                                        "Document does not exist");
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return TimeTable(shifts: snapshot.data!, lop: _lop,);
                                  }
                                  return const Text("Loading.....");
                                },
                              ),
                              UserTable(
                                titles: const [
                                  "ID",
                                  "Name",
                                  "Gender",
                                  "DOB",
                                  "email",
                                  "Phone Number",
                                  "Address"
                                ],
                                users: students,
                                className: _lop.name,
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : main,
    );
  }
}
