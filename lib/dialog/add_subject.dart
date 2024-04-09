import 'dart:collection';
import 'dart:html' as html;
import 'package:admin/data/subject.dart';
import 'package:admin/model/subject.dart';
import 'package:flutter/material.dart';

class AddSubjectDialog extends StatefulWidget {
  AddSubjectDialog({key, required this.grade})
      : super(key: key);
  final String grade;

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  late String _grade;
  String nameSubject = "";

  @override
  void initState() {
    super.initState();
    _grade = widget.grade;
  }

  HashSet<String> listDepartment(List<Subject> subjects) {
    HashSet<String> departments = HashSet<String>();
    for (var element in subjects) {
      departments.add(element.name);
    }
    return departments;
  }

  @override
  void dispose() {
    // Cancel timers, remove listeners, or dispose of resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add documentation to Subject"),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const Expanded(child: Text("Level: ")),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: _grade,
                      readOnly: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.text_fields),
                          prefixIconColor: Colors.blue,
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
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
                      initialValue: nameSubject,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.text_fields),
                        prefixIconColor: Colors.blue,
                        border: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          nameSubject = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            )),
        TextButton(
            onPressed: () {
              try {
                Subject sub = Subject(
                    id: "${nameSubject.toLowerCase().trim()}$_grade",
                    name: nameSubject,
                    level: int.parse(_grade),
                    documents: []);
                setState(() {
                  addSubjectByGrade(int.parse(_grade), sub);
                  Navigator.pop(context, sub);
                });
              } catch (e) {
                print("Error: $e");
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
