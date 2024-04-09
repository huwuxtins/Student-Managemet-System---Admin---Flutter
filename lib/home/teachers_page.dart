import 'package:admin/data/teacher.dart';
import 'package:admin/model/teacher.dart';
import 'package:admin/page/change_user.dart';
import 'package:admin/widget/teacher_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
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
          SizedBox(
            height: 1000,
            width: double.infinity,
            child: FutureBuilder<Map<String, List<Teacher>?>>(
              initialData: const {},
              future: getTeacherByDepartment(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (!snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    children: snapshot.data!.entries.map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                "Department ${e.key}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Teacher? changedUser = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChangeUser(
                                                mainMajor: e.key,
                                                users:
                                                    snapshot.data![e.key]!)));
                                    if (changedUser != null) {
                                      UserCredential userCredential = await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: changedUser.email,
                                              password: changedUser.password);

                                      changedUser.id = userCredential.user!.uid;
                                      setState(() {
                                        snapshot.data![e.key]!.add(changedUser);
                                        addTeacher(changedUser);
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.red),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: GridView.builder(
                                itemCount: e.value!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 3 / 1),
                                itemBuilder: (context, index) {
                                  return TeacherItem(
                                    teacher: e.value![index],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
                return const Text("Loading...");
              },
            ),
          ),
        ]),
      ),
    );
  }
}
