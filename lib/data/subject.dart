import 'package:admin/model/document.dart';
import 'package:admin/model/subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Subject>?> getAllSubject() async {
  List<Subject> listSubject = [];
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("subjects").get();
  for (var doc in querySnapshot.docs) {
    listSubject.add(Subject.fromFirestore(doc, []));
  }

  return listSubject;
}

Future<Subject?> getSubjectById(String id) async {
  DocumentSnapshot query =
      await FirebaseFirestore.instance.collection("subjects").doc(id).get();

  return Subject.fromJsonDoc(query, []);
}

Future<Map<int, List<Subject>>?> getSubjectByGrade(int grade) async {
  Map<int, List<Subject>> listSubject = {};
  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection("subjects")
      .where("level", isEqualTo: grade)
      .get();
  List<Subject> subjects = [];
  try {
    for (var doc in query.docs) {
      List<String?> links = (doc.data()['docs'] != null)
          ? List<String?>.from(doc.data()['docs'])
          : [];

      subjects.add(Subject.fromFirestore(doc, await getDocByLink(links)));
    }
  } catch (e) {
    print(e);
  }
  listSubject.addAll({grade: subjects});
  return listSubject;
}

Future<List<Document>> getDocByLink(List<String?> links) async {
  List<Document> docs = [];
  for (var link in links) {
    if (link != null) {
      DocumentSnapshot<Map<String, dynamic>> query =
          await FirebaseFirestore.instance.collection("docs").doc(link).get();
      Document doc = Document.fromFirebase(query);
      docs.add(doc);
    }
  }
  return docs;
}

Future<void> addSubjectByGrade(int grade, Subject subject) async {
  await FirebaseFirestore.instance
      .collection("departments")
      .doc(subject.name.toLowerCase())
      .set({'name': subject.name});

  await FirebaseFirestore.instance
      .collection("subjects")
      .doc(subject.id)
      .set(subject.toJson());
}

Future<void> updateDocInSubject(String subjectId, Document doc) async {
  await FirebaseFirestore.instance
      .collection("subjects")
      .doc(subjectId)
      .update({
    "docs": FieldValue.arrayUnion([doc.linkPDF])
  });

  await FirebaseFirestore.instance
      .collection("docs")
      .doc(doc.linkPDF)
      .set(doc.toJson());
}
