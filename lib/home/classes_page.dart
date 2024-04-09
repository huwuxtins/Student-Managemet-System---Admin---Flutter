import 'package:admin/data/classes.dart';
import 'package:admin/model/class.dart';
import 'package:admin/widget/class_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

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
            child: FutureBuilder<Map<int, List<Class>>?>(
              initialData: const {},
              future: getClasses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (!snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<int, List<Class>> data = snapshot.data!;
                  return ListView(
                    children: data.entries.map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            "Grade ${e.key}",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(color: Colors.red),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: GridView.builder(
                                itemCount: e.value.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 4 / 2),
                                itemBuilder: (context, index) {
                                  return ClassItem(
                                    lop: e.value[index],
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
                return const Text("Loading");
              },
            ),
          ),
        ]),
      ),
    );
  }
}
