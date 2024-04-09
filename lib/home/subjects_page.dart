import 'package:admin/data/subject.dart';
import 'package:admin/dialog/add_subject.dart';
import 'package:admin/model/subject.dart';
import 'package:admin/widget/subject_item.dart';
import 'package:flutter/material.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
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
            child: Column(
              children: [10, 11, 12].map((e) {
                return FutureBuilder<Map<int, List<Subject>>?>(
                  initialData: const {},
                  future: getSubjectByGrade(e),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (!snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                "Grade $e",
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
                                    Subject? sub = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddSubjectDialog(grade: "$e");
                                      },
                                    );

                                    if (sub != null) {
                                      setState(() {
                                        snapshot.data![e]!.add(sub);
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
                                itemCount: snapshot.data![e]!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 3 / 1),
                                itemBuilder: (context, index) {
                                  return SubjectItem(
                                    subject: snapshot.data![e]![index],
                                    grade: e,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const Text("Loading...");
                  },
                );
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
