import 'package:admin/home/classes_page.dart';
import 'package:admin/home/home_page.dart';
import 'package:admin/home/login_page.dart';
import 'package:admin/home/notifications_page.dart';
import 'package:admin/home/subjects_page.dart';
import 'package:admin/home/teachers_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({key, required this.selectPage}) : super(key: key);

  final Function selectPage;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Function _selectPage;

  @override
  void initState() {
    super.initState();
    _selectPage = widget.selectPage;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            decoration: BoxDecoration(color: Colors.blue),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://th.bing.com/th/id/R.6279cf832b5649c99c1dcec3a2168b23?rik=KA4UHfTAjPfq5Q&pid=ImgRaw&r=0"),
              ),
              title: Text(
                "Nguyen Huu Tin",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "nguyenhuutin124@gmail.com",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              _selectPage(const HomePage());
            },
          ),
          ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Classes"),
              onTap: () {
                _selectPage(const ClassesPage());
              }),
          ListTile(
              leading: const Icon(Icons.co_present_rounded),
              title: const Text("Teachers"),
              onTap: () {
                _selectPage(const TeachersPage());
              }),
          ListTile(
              leading: const Icon(Icons.menu_book_rounded),
              title: const Text("Subjects"),
              onTap: () {
                _selectPage(const SubjectsPage());
              }),
          ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                _selectPage(const NotificationPage());
              }),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
                          },
                        )));
              }),
        ],
      ),
    );
  }
}
