import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/costumerUI/costumer_main.dart';
import 'package:laundryapp/main.dart';
import 'package:laundryapp/registerpage.dart';
import 'package:laundryapp/user_auth.dart';

class LoginVerification extends StatefulWidget {
  const LoginVerification({super.key});

  @override
  State<LoginVerification> createState() => _LoginVerificationState();
}

class _LoginVerificationState extends State<LoginVerification> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong!"),
            ),
          );
        } else if (snapshot.hasData) {
          return const UserAuth();
        } else {
          return const LoginPageUI();
        }
      },
    );
  }
}

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({super.key});

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {

  final getDate = DateTime.now();

  bool obscureText = true;
  final formKey = GlobalKey<FormState>();

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                      height: 200,
                      width: 250,
                      child: Image.asset(
                        'assets/washing-machine.png',
                        fit: BoxFit.fill,
                      )),
                  Text('3MG LAUNDRY SHOP',
                      style: GoogleFonts.breeSerif(
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Text('"Every wash is worth your Cash"',
                      style: GoogleFonts.breeSerif(
                        textStyle: const TextStyle(
                          fontSize: 15,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (emailController.text.isEmpty || value == null) {
                        return 'Please fill this field';
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      label: Text(
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
                    obscureText: obscureText,
                    validator: (value) {
                      if (passwordController.text.isEmpty || value == null) {
                        return 'Please fill this field';
                      }
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: obscureText
                              ? const Icon(Icons.remove_red_eye)
                              : const Icon(Icons.lock)),
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
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      final docUser = FirebaseFirestore.instance.collection('loginLogs').doc();

                      docUser.set({
                        'id': docUser.id,
                        'email':emailController.text,
                        'status': 'login',
                        'time': DateFormat('hh:mm a').format(getDate),
                        'date': DateFormat('yyyy-MM-dd').format(getDate),
                      });
                      signIn();
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
                        "Don't have an account?",
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
                            return RegistrationPage();
                          }));
                        },
                        child: Text('Create Account',
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

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Fluttertoast.showToast(
        msg: 'Login Succeed',
        fontSize: 15,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: e.message.toString(),
        fontSize: 15,

      );
      // setState(() {
      //   _errorMsg = e.message.toString();
      // });
    }

    //Navigator.of(context) not working!!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
