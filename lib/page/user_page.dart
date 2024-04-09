import 'package:admin/data/classes.dart';
import 'package:admin/data/shift.dart';
import 'package:admin/model/class.dart';
import 'package:admin/model/shift.dart';
import 'package:admin/model/teacher.dart';
import 'package:admin/widget/custom_drawer.dart';
import 'package:admin/widget/time_table_teacher.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Teacher __teacher;
  List<String> classes = [];
  List<String> classesTeacher = [];
  Map<String, Map<int, List<Shift>>> timeTableAll = {};

  Map<int, List<Shift>> scheduleOfTeacher = {
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

  Map<int, List<Shift>> getScheduleBySubjectAndClass(String LOP) {
    Map<int, List<Shift>> result = {};
    String subject = __teacher.mainMajor;

    timeTableAll.forEach((lop, timeTable) {
      if (LOP == lop) {
        timeTable.forEach((shift, listShift) {
          List<Shift> subjectByShift = [];
          for (var element in listShift) {
            if (element.subject != null && element.teacher == null) {
              if (element.subject!.name == subject) {
                subjectByShift.add(element);
              } else {
                subjectByShift.add(Shift(subject: null, teacher: null));
              }
            } else {
              subjectByShift.add(Shift(subject: null, teacher: null));
            }
          }
          result.addAll({shift: subjectByShift});
        });
      }
    });
    return result;
  }

  bool checkSameShift(String LOP) {
    Map<int, List<Shift>> lop = getScheduleBySubjectAndClass(LOP);

    for (var day in scheduleOfTeacher.keys) {
      if (scheduleOfTeacher.containsKey(day) && lop.containsKey(day)) {
        var shiftsSchedule = scheduleOfTeacher[day]!;
        var shiftsLop = lop[day]!;

        if (shiftsSchedule.length != shiftsLop.length) {
          return false;
        }
        for (var i = 0; i < shiftsSchedule.length; i++) {
          if (shiftsSchedule[i].subject != null &&
              shiftsLop[i].subject != null) {
            return false;
          }
        }
      } else {
        return false;
      }
    }
    return true;
  }

  Widget? main;

  @override
  void initState() {
    super.initState();
    __teacher = widget.teacher;
    for (var element in __teacher.classes!) {
      classesTeacher.add(element.name);
    }
    loadClassNames();
  }

  void selectPage(Widget page) {
    setState(() {
      main = page;
    });
  }

  Future<List<String>> getClassNames() async {
    List<String> classes = [];
    Map<int, List<Class>>? classByGrade = await getClasses();
    classByGrade!.forEach((key, value) {
      value.forEach((element) {
        classes.add(element.name);
      });
    });
    return classes;
  }

  Future<void> loadClassNames() async {
    List<String> classNames = await getClassNames();
    setState(() {
      classes = classNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        title: const Text(
          "User Detail",
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://th.bing.com/th/id/R.942c4d421940ae4cafaec8a00f447f4a?rik=R0k%2fFN45EoLpGg&pid=ImgRaw&r=0"),
                              ),
                              Text(
                                __teacher.name,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                __teacher.email,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              ),
                            ]),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    "Detail",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
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
                                    "TimeOff",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 700,
                              child: TabBarView(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.25),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Basic information",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25),
                                                ),
                                                const Divider(),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Fullname: ${__teacher.name}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Gender: ${__teacher.gender}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Birthday: ${__teacher.dob}"),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.25),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Contacts",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25),
                                                ),
                                                const Divider(),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Email: ${__teacher.email}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Phone number: ${__teacher.phoneNumber}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Address: ${__teacher.address}"),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.25),
                                                spreadRadius: 2,
                                                blurRadius: 2,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Major",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25),
                                                ),
                                                const Divider(),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Department: ${__teacher.mainMajor}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Salary: ${__teacher.salary}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                      "Start Date: ${__teacher.startDate}"),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ]),
                                FutureBuilder<
                                    Map<String, Map<int, List<Shift>>>>(
                                  initialData: {
                                    "": {
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
                                    }
                                  },
                                  future: getTimeTables(classes),
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
                                      timeTableAll = snapshot.data!;
                                      return TimeTableTeacher(
                                        shifts: scheduleOfTeacher,
                                        onChange: checkSameShift,
                                        teacher: __teacher,
                                        timeTableAll: snapshot.data!,
                                      );
                                    }
                                    return const Text("Loading...");
                                  },
                                ),
                                Row(children: [
                                  // TimeTable(shifts: ),
                                ]),
                              ]),
                            ),
                          ],
                        ),
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
