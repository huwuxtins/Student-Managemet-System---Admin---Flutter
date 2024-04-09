import 'package:admin/widget/block_item.dart';
import 'package:admin/widget/chart_grouped.dart';
import 'package:admin/widget/todo_item.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Welcome Admin!",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlockItem(
                    title: "Students",
                    number: 20534,
                    image:
                        "https://static.vecteezy.com/system/resources/previews/000/348/344/original/vector-male-student-icon.jpg"),
                BlockItem(
                    title: "Teachers",
                    number: 20534,
                    image:
                        "https://th.bing.com/th/id/OIP.ju0KNF2lzdRQ5ia8qxS-NwHaHa?rs=1&pid=ImgDetMain"),
                BlockItem(
                    title: "Notifications",
                    number: 20534,
                    image:
                        "https://static.vecteezy.com/system/resources/previews/000/378/113/original/notification-vector-icon.jpg"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 500,
                  width: 750,
                  child: ChartGrouped(
                    ordinalList: [
                      [
                        OrdinalData(domain: 'weak', measure: 10),
                        OrdinalData(domain: 'average', measure: 25),
                        OrdinalData(domain: 'credit', measure: 80),
                        OrdinalData(domain: 'distinction', measure: 45),
                      ],
                      [
                        OrdinalData(domain: 'weak', measure: 25),
                        OrdinalData(domain: 'average', measure: 30),
                        OrdinalData(domain: 'credit', measure: 50),
                        OrdinalData(domain: 'distinction', measure: 30),
                      ],
                      [
                        OrdinalData(domain: 'weak', measure: 20),
                        OrdinalData(domain: 'average', measure: 25),
                        OrdinalData(domain: 'credit', measure: 75),
                        OrdinalData(domain: 'distinction', measure: 42),
                      ],
                    ],
                  ),
                ),
                ToDoItem()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
