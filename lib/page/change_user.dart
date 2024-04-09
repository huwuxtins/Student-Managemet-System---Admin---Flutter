import 'dart:collection';

import 'package:admin/data/subject.dart';
import 'package:admin/model/student.dart';
import 'package:admin/model/subject.dart';
import 'package:admin/model/teacher.dart';
import 'package:admin/model/user.dart';
import 'package:admin/widget/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChangeUser extends StatefulWidget {
  const ChangeUser({key, this.user, this.mainMajor, required this.users})
      : super(key: key);

  final UserCustom? user;
  final String? mainMajor;
  final List<UserCustom> users;

  @override
  State<ChangeUser> createState() => _ChangeUserState();
}

class _ChangeUserState extends State<ChangeUser> {
  late UserCustom? _user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = "";
  String gender = "Male";
  DateTime dob = DateTime.now();
  String email = "";
  String password = "";
  String phoneNumber = "";
  String address = "";
  bool isObscureText = false;
  String ROLE = "Student";
  int salary = 0;
  String _mainMajor = "";
  DateTime startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    if (widget.mainMajor != null) {
      _mainMajor = widget.mainMajor!;
    }
    if (_user != null) {
      name = _user!.name;
      gender = _user!.gender;
      dob = _user!.dob;
      email = _user!.email;
      password = _user!.password;
      phoneNumber = _user!.phoneNumber;
      address = _user!.address;
      if (_user is Teacher) {
        ROLE = "Teacher";
      }
    }
  }

  HashSet<String> listDepartment(List<Subject> subjects) {
    HashSet<String> departments = HashSet<String>();
    for (var element in subjects) {
      departments.add(element.name);
    }
    return departments;
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 750,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: const Color.fromARGB(255, 208, 208, 208))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              (_user == null) ? "Add User" : "Update User",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Expanded(child: Text("ROLE: ")),
                                Expanded(
                                  flex: 2,
                                  child: DropdownButton(
                                    value: ROLE,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Student",
                                        child: Text("Student"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Teacher",
                                        child: Text("Teacher"),
                                      )
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        ROLE = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Name: ")),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    initialValue: name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter user's name";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.text_fields),
                                        prefixIconColor: Colors.blue,
                                        labelText: "Enter name",
                                        border: OutlineInputBorder(),
                                        errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Expanded(child: Text("Gender: ")),
                                    Expanded(
                                      flex: 2,
                                      child: DropdownButton(
                                        value: gender,
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Male",
                                            child: Text("Male"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Female",
                                            child: Text("Femle"),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    const Text("Birthday: "),
                                    IconButton(
                                      onPressed: () async {
                                        final DateTime? time =
                                            await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2999),
                                        );
                                        setState(() {
                                          dob = time!;
                                        });
                                      },
                                      icon: Row(children: [
                                        const Icon(Icons.date_range),
                                        Text("$dob")
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Email: ")),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    initialValue: email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter email";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        prefixIconColor: Colors.blue,
                                        labelText: "Enter email",
                                        border: OutlineInputBorder(),
                                        errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Password: ")),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    obscureText: !isObscureText,
                                    initialValue: password,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter password";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.password),
                                        prefixIconColor: Colors.blue,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isObscureText = !isObscureText;
                                            });
                                          },
                                          icon: Icon(isObscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        labelText: "Enter password",
                                        border: const OutlineInputBorder(),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Phone number: ")),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    initialValue: phoneNumber,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter phone number";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      phoneNumber = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.phone),
                                        prefixIconColor: Colors.blue,
                                        labelText: "Enter phoneNumber",
                                        border: OutlineInputBorder(),
                                        errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Expanded(child: Text("Address: ")),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    initialValue: address,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter address";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      address = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.location_city),
                                        prefixIconColor: Colors.blue,
                                        labelText: "Enter address",
                                        border: OutlineInputBorder(),
                                        errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: (ROLE == "Teacher")
                                ? Row(
                                    children: [
                                      const Expanded(child: Text("Salary: ")),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: salary.toString(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter salary";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            salary = int.parse(value);
                                          },
                                          decoration: const InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.location_city),
                                              prefixIconColor: Colors.blue,
                                              labelText: "Enter salary",
                                              border: OutlineInputBorder(),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red))),
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: (ROLE == "Teacher")
                                ? Row(
                                    children: [
                                      const Expanded(
                                          child: Text("Main major: ")),
                                      Expanded(
                                        flex: 2,
                                        child: FutureBuilder<List<Subject>?>(
                                          initialData: const [],
                                          future: getAllSubject(),
                                          builder: (context, snapshot) {
                                            return DropdownButton(
                                              value: (_mainMajor.isNotEmpty)? _mainMajor: listDepartment(snapshot.data!).toList()[0],
                                              items:
                                                  listDepartment(snapshot.data!)
                                                      .map((e) {
                                                return DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _mainMajor = value;
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: (ROLE == "Teacher")
                                ? Row(
                                    children: [
                                      const Expanded(
                                          child: Text("StartDate: ")),
                                      Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          onPressed: () async {
                                            final DateTime? time =
                                                await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2999),
                                            );
                                            setState(() {
                                              startDate = time!;
                                            });
                                          },
                                          icon: Row(children: [
                                            const Icon(Icons.date_range),
                                            Text("$startDate")
                                          ]),
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        Navigator.pop(
                                            context,
                                            (ROLE == "Student")
                                                ? Student(
                                                    id: (_user == null)
                                                        ? const Uuid().v4()
                                                        : _user!.id,
                                                    name: name,
                                                    dob: dob,
                                                    gender: gender,
                                                    email: email,
                                                    password: password,
                                                    phoneNumber: phoneNumber,
                                                    address: address)
                                                : Teacher(
                                                    id: (_user == null)
                                                        ? const Uuid().v4()
                                                        : _user!.id,
                                                    name: name,
                                                    dob: dob,
                                                    gender: gender,
                                                    email: email,
                                                    password: password,
                                                    phoneNumber: phoneNumber,
                                                    address: address,
                                                    salary: salary,
                                                    mainMajor: _mainMajor,
                                                    startDate: startDate,
                                                    classes: []));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : main,
    );
  }
}
