import 'dart:html' as html;
import 'package:admin/data/subject.dart';
import 'package:admin/model/document.dart';
import 'package:admin/model/subject.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddDocDialog extends StatefulWidget {
  AddDocDialog({key, required this.subject, this.onAdd}) : super(key: key);
  final Subject subject;
  Function? onAdd;

  @override
  State<AddDocDialog> createState() => _AddDocDialogState();
}

class _AddDocDialogState extends State<AddDocDialog> {
  late Subject _subject;
  late Function? onAdd;
  String nameDoc = "";
  DateTime createdAt = DateTime.now();
  String linkPDF = "";
  var file;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
    onAdd = widget.onAdd;
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
                  const Expanded(child: Text("Subject's name: ")),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: _subject.name,
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
                  const Expanded(child: Text("Title: ")),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: nameDoc,
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
                          nameDoc = value;
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
                  const Expanded(child: Text("Created At: ")),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () async {
                        final DateTime? time = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2999),
                        );
                        setState(() {
                          createdAt = time!;
                        });
                      },
                      icon: Row(children: [
                        const Icon(Icons.date_range),
                        Text("$createdAt")
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () async {
                  if (kIsWeb) {
                    html.FileUploadInputElement uploadInput =
                        html.FileUploadInputElement();
                    uploadInput.multiple = false;
                    uploadInput.accept = '.pdf'; // Limit file type to xlsx
                    uploadInput.click();

                    uploadInput.onChange.listen((e) {
                      final files = uploadInput.files;
                      if (files != null && files.isNotEmpty) {
                        file = files[0];
                      }
                    });
                  }
                },
                child: const Text(
                  "Import from Excel file",
                  style: TextStyle(color: Colors.blue),
                )),
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
                String fileName = "${const Uuid().v4()}_${file.name}";

                setState(() {
                  Document doc = Document(
                      id: fileName,
                      name: nameDoc,
                      linkPDF: fileName,
                      createdAt: createdAt);
                  _subject.documents.add(doc);
                  onAdd!(_subject.documents);
                  updateDocInSubject(_subject.id, doc);
                });
                FirebaseStorage.instance
                    .ref("documents")
                    .child(fileName)
                    .putBlob(file.slice());
              } catch (e) {
                print("Error: $e");
              }
              Navigator.pop(context);
            },
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
