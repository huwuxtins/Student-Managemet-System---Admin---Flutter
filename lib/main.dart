import 'package:admin/firebase_options.dart';
import 'package:admin/home/login_page.dart';
import 'package:admin/page/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // try {
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithEmailAndPassword(
  //     email: 'nguyenhuutin124@gmail.com',
  //     password: '123456',
  //   );
  //   // User is successfully authenticated
  // } catch (e) {
  //   // Handle authentication errors
  //   print('Failed to sign in: $e');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Student Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
