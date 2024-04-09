import 'package:admin/model/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<NotificationApp>?> getNotification() async {
  List<NotificationApp> notifications = [];

  QuerySnapshot<Map<String, dynamic>> query =
      await FirebaseFirestore.instance.collection("notifications").get();

  for (var doc in query.docs) {
    notifications.add(NotificationApp.fromFirebase(doc));
  }

  return notifications;
}

Future<void> addNotification(NotificationApp notificationApp) async {
  await FirebaseFirestore.instance
      .collection("notifications")
      .doc(notificationApp.id)
      .set(notificationApp.toJson());
}
