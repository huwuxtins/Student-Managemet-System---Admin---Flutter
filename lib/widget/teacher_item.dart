import 'package:admin/model/teacher.dart';
import 'package:admin/page/user_page.dart';
import 'package:flutter/material.dart';

class TeacherItem extends StatefulWidget {
  const TeacherItem({key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  @override
  State<TeacherItem> createState() => _TeacherItemState();
}

class _TeacherItemState extends State<TeacherItem> {
  late Teacher _teacher;

  @override
  void initState() {
    super.initState();
    _teacher = widget.teacher;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(teacher: _teacher),
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
              height: 100,
              padding: const EdgeInsets.all(10.0),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://th.bing.com/th/id/R.0fcf53bfb204ab226b1e69a084aa4475?rik=czHogm%2bV4kwY6Q&pid=ImgRaw&r=0"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_teacher.name,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("Email: ${_teacher.email}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
