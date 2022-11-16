import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryapp/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laundryapp/main.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'CREATE ACCOUNT',
                      style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (firstnameController.text.isEmpty || value == null) {
                        return 'Please fill this field';
                      }
                    },
                    controller: firstnameController,
                    decoration: InputDecoration(
                      label: const Text(
                        'FIRSTNAME',
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (lastnameController.text.isEmpty || value == null) {
                        return 'Please fill this field';
                      }
                    },
                    controller: lastnameController,
                    decoration: InputDecoration(
                      label: const Text(
                        'LASTNAME',
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (emailController.text.isEmpty || value == null) {
                        return 'Please fill this field';
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      label: const Text(
                        'EMAIL',
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (passwordController.text.isEmpty || value == null) {
                        return 'Please fill this field';
                      }
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      label: const Text(
                        'PASSWORD',
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      signUp();
                    },
                    child: Text(
                      'CONFIRM',
                      style: GoogleFonts.merriweather(
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.merriweather(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const LoginPageUI();
                          }));
                        },
                        child: Text('Log In',
                            style: GoogleFonts.merriweather(
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      createUserAuth();

      Fluttertoast.showToast(
        msg: 'Account Created',
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e.message.toString(),
        fontSize: 15,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }

    //Navigator.of(context) not working!!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future createUserAuth() async {
    final docUser = FirebaseFirestore.instance.collection('userAuth').doc();

    docUser.set({
      'firstname':firstnameController.text,
      'lastname': lastnameController.text,
      'id': docUser.id,
      'email': emailController.text,
      'password': passwordController.text,
      'authentication': 'customer',
    });
  }
}
