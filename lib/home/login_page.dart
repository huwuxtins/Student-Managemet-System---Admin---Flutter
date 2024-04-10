import 'dart:async';

import 'package:admin/page/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  bool isObscureText = false;
  bool isLogin = false;

  bool isSuccess = false;

  Future<void> closeMessage() async {
    setState(() {
      isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 600,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Login Form",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Expanded(child: Text("Email: ")),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Colors.blue,
                            labelText: "Enter email",
                            border: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Expanded(child: Text("Password: ")),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        obscureText: !isObscureText,
                        initialValue: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
                            prefixIconColor: Colors.blue,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscureText = !isObscureText;
                                });
                              },
                              icon: Icon(isObscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            labelText: "Enter password",
                            border: const OutlineInputBorder(),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: (isLogin)
                    ? Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (isSuccess)
                              ? const Color.fromARGB(255, 98, 216, 102)
                              : const Color.fromARGB(255, 238, 84, 73),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          (isSuccess) ? "Login successfull!" : "Login failed!",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .onError((error, stackTrace) {
                        setState(() {
                          isLogin = true;
                          isSuccess = false;
                        });
                        throw Exception();
                      }).then((value) {
                        setState(() {
                          isLogin = true;
                          isSuccess = true;
                        });
                      });

                      Timer.periodic(const Duration(seconds: 3), (timer) {
                        setState(() {
                          isLogin = false;

                          if (isSuccess) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const Main();
                              },
                            ));
                            isSuccess = false;
                          }
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
