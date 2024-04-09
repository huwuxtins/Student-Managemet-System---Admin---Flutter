import 'package:admin/model/task.dart';
import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  ToDoItem({super.key});

  final List<Task> tasks = [
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
    Task("346734hsd", "Post timetable 12A1", DateTime(2024, 4, 5),
        "localhost/post-timetable"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Text("Tasks", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(
            height: 500,
            width: double.infinity,
            child: ListView.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.task,
                      color: Colors.blue,
                    ),
                    title: Text(tasks[index].title),
                    subtitle: Text("Deadline: ${tasks[index].deadline}"),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
