import 'dart:html' as html;
import 'package:admin/data/notification.dart';
import 'package:admin/model/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:uuid/uuid.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<NotificationApp> notifications = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String title = "";
  String type = "TimeTable";
  String content = "";
  DateTime createdAt = DateTime.now();
  var file;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  hintText: "Enter grade, class, ...",
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
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.blue,
                        child: const Text(
                          "Notifications",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<NotificationApp>?>(
                          initialData: const [],
                          future: getNotification(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }

                            if (!snapshot.hasData && snapshot.data!.isEmpty) {
                              return const Text("Document does not exist");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              notifications = snapshot.data!;
                              return ListView.separated(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      selectedColor: Colors.blue,
                                      leading: const Icon(Icons.notifications,
                                          color: Colors.blue),
                                      title: Text(
                                        notifications[index].title,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          "Post at: ${notifications[index].createdAt}"),
                                      onTap: () async {
                                        await FirebaseStorage.instance
                                            .ref("notifications")
                                            .child(notifications[index].linkPDF)
                                            .getDownloadURL()
                                            .then((value) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              final controller =
                                                  PdfControllerPinch(
                                                      document:
                                                          PdfDocument.openData(
                                                              InternetFile.get(
                                                                  value,
                                                                  headers: {
                                                    "Access-Control-Allow-Origin":
                                                        "*",
                                                    'Access-Control-Allow-Methods':
                                                        'GET, POST, PUT, DELETE',
                                                    'Access-Control-Allow-Headers':
                                                        'Origin, Content-Type, X-Auth-Token'
                                                  })));
                                              return PdfViewPinch(
                                                controller: controller,
                                                padding: 100,
                                              );
                                            },
                                          );
                                        });
                                      },
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemCount: notifications.length);
                            }
                            return const Text("Loading");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                color: Colors.blue,
                                child: const Text(
                                  "Add notification",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
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
                                      initialValue: title,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter title";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        title = value;
                                      },
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          prefixIconColor: Colors.blue,
                                          labelText: "Enter title",
                                          border: OutlineInputBorder(),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Content: ")),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      initialValue: content,
                                      maxLines: 5,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter content";
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        content = value;
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Enter content",
                                          border: OutlineInputBorder(),
                                          errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Type: ")),
                                  Expanded(
                                      flex: 2,
                                      child: DropdownButton(
                                        value: type,
                                        items: [
                                          "TimeTable",
                                          "Teacher",
                                          "Student",
                                          "School"
                                        ].map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              type = value;
                                            });
                                          }
                                        },
                                      )),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  if (kIsWeb) {
                                    html.FileUploadInputElement uploadInput =
                                        html.FileUploadInputElement();
                                    uploadInput.multiple = false;
                                    uploadInput.accept =
                                        '.pdf'; // Limit file type to xlsx
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
                                  "Import file",
                                  style: TextStyle(color: Colors.blue),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        String randomID = const Uuid().v4();
                                        String fileName =
                                            "${randomID}_${file.name}";
                                        NotificationApp notificationApp =
                                            NotificationApp(
                                                id: randomID,
                                                title: title,
                                                type: type,
                                                content: content,
                                                linkPDF: fileName,
                                                createdAt: createdAt);

                                        addNotification(notificationApp);

                                        FirebaseStorage.instance
                                            .ref("notifications")
                                            .child(fileName)
                                            .putBlob(file.slice());

                                        setState(() {
                                          notifications.add(notificationApp);
                                        });
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
                              ],
                            )
                          ])),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
