import 'dart:html' as html;
import 'package:admin/dialog/add_doc_dialog.dart';
import 'package:admin/model/document.dart';
import 'package:admin/model/subject.dart';
import 'package:admin/widget/custom_drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class DetailSubject extends StatefulWidget {
  const DetailSubject({key, required this.subject}) : super(key: key);

  final Subject subject;

  @override
  State<DetailSubject> createState() => _DetailSubjectState();
}

class _DetailSubjectState extends State<DetailSubject> {
  late Subject _subject;
  bool isChoosen = false;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
  }

  Widget? main;

  void selectPage(Widget page) {
    setState(() {
      main = page;
    });
  }

  void addNewDoc(List<Document> doc) {
    setState(() {
      _subject.documents = doc;
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _subject.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Level: ${_subject.level}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Number of document: ${_subject.documents.length}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: ElevatedButton(
                              onPressed: () {
                                if (!isChoosen) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddDocDialog(
                                            subject: _subject,
                                            onAdd: addNewDoc);
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                isChoosen ? "Delete" : "Add",
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: (isChoosen)
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isChoosen = !isChoosen;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ))
                              : null,
                        ),
                      ],
                    ),
                    DataTable(
                        columns: const [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Date modified")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: _subject.documents.map((e) {
                          return DataRow(
                              onSelectChanged: (value) {
                                isChoosen = value!;
                              },
                              cells: [
                                DataCell(Text(e.name)),
                                DataCell(Text("${e.createdAt}")),
                                DataCell(
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await FirebaseStorage.instance
                                                .ref("documents")
                                                .child(e.linkPDF)
                                                .getDownloadURL()
                                                .then((value) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  final controller =
                                                      PdfControllerPinch(
                                                          document: PdfDocument
                                                              .openData(
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
                                          icon: const Icon(
                                            Icons.visibility,
                                            color: Colors.blue,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            String url = await FirebaseStorage
                                                .instance
                                                .ref("documents")
                                                .child(e.linkPDF)
                                                .getDownloadURL();
                                            html.AnchorElement anchorElement =
                                                html.AnchorElement(href: url)
                                                  ..setAttribute(
                                                      'download', e.linkPDF)
                                                  ..click();
                                          },
                                          icon: const Icon(Icons.download,
                                              color: Colors.blue))
                                    ],
                                  ),
                                )
                              ]);
                        }).toList())
                  ],
                ),
              ),
            )
          : main,
    );
  }
}
