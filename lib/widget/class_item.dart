import 'package:admin/model/class.dart';
import 'package:admin/page/class_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClassItem extends StatelessWidget {
  final Class lop;
  ClassItem({
    key,
    required this.lop,
  }) : super(key: key);

  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        isHover = value;
      },
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClassPage(lop: lop)));
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: isHover
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              lop.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const Divider(
              indent: 50,
              endIndent: 50,
            ),
            Text(
              "Number of student: ${lop.students.length}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
