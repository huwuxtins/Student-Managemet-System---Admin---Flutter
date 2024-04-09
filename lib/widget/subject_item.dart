import 'package:admin/model/subject.dart';
import 'package:admin/page/detail_subject.dart';
import 'package:flutter/material.dart';

class SubjectItem extends StatefulWidget {
  const SubjectItem({key, required this.subject, required this.grade})
      : super(key: key);

  final Subject subject;
  final int grade;

  @override
  State<SubjectItem> createState() => _SubjectItemState();
}

class _SubjectItemState extends State<SubjectItem> {
  late Subject _subject;
  late int _grade;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
    _grade = widget.grade;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSubject(subject: _subject),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.blue),
          child: Row(children: [
            Container(
              height: 200,
              padding: const EdgeInsets.all(10.0),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://th.bing.com/th/id/OIP.UZbJjhfcC_wLBwaGYxSDLAHaHa?rs=1&pid=ImgDetMain"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${_subject.name} $_grade",
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ),
    );
  }
}
