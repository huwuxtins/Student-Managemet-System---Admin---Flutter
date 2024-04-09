import 'package:admin/home/home_page.dart';
import 'package:admin/widget/custom_drawer.dart';
import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Widget main = HomePage();

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
          "Student Management System",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(selectPage: selectPage),
      body: main,
    );
  }
}
