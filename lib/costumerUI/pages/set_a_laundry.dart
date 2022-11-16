import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SetALaundryPage extends StatefulWidget {
  const SetALaundryPage({super.key});

  @override
  State<SetALaundryPage> createState() => _SetALaundryPageState();
}

class _SetALaundryPageState extends State<SetALaundryPage> {
  final datetimeNow = DateTime.now();
  final formKey = GlobalKey<FormState>();
  String schedule = 'null';

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final streetController = TextEditingController();
  final brgyController = TextEditingController();
  final municipalityController = TextEditingController();
  final provinceController = TextEditingController();
  final postalcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'PERSONAL INFORMATION',
                style: GoogleFonts.merriweather(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              dataTextField(),
              const SizedBox(height: 15),
              Text(
                'ADDRESSES',
                style: GoogleFonts.merriweather(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (streetController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: streetController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'HOUSE NO. STREET, BUILDING',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (brgyController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: brgyController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'BARANGAY',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (municipalityController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: municipalityController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'MUNICIPALITY',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (provinceController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: provinceController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'PROVINCE',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (postalcodeController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: postalcodeController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'POSTAL CODE',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'DROP-OFF',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            schedule = 'dropoff';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: schedule == 'dropoff'
                                ? Colors.teal[200]
                                : Colors.white,
                            border: const Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              left: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          height: 70,
                          width: 100,
                          child: Image.asset(
                            'assets/drop-off.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      const Text(
                        'PICK-UP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            schedule = 'pickup';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: schedule == 'pickup'
                                ? Colors.teal[200]
                                : Colors.white,
                            border: const Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              top: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              left: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          height: 70,
                          width: 100,
                          child: Image.asset(
                            'assets/pickup.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) return;

                  if (schedule != 'null') {
                    setLaundry();

                    firstnameController.clear();
                    lastnameController.clear();
                    contactController.clear();
                    emailController.clear();
                    streetController.clear();
                    brgyController.clear();
                    municipalityController.clear();
                    provinceController.clear();
                    postalcodeController.clear();
                    Fluttertoast.showToast(msg: 'Laundry Schedule Set');
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please select preferred schedule');
                  }
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
            ],
          ),
        ),
      ),
    );
  }

  Widget dataTextField() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userAuth')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return Text('Something went wrong');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          final data = snapshot.requireData;
          firstnameController.text = data.docs.first['firstname'];
          lastnameController.text = data.docs.first['lastname'];
          emailController.text = data.docs.first['email'];

          return Column(children: [
            TextFormField(
                validator: (value) {
                  if (firstnameController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: firstnameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'FIRSTNAME',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (lastnameController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: lastnameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'LASTNAME',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (contactController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: contactController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'CONTACT NUMBER',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (emailController.text.isEmpty || value == null) {
                    return 'Please fill this field';
                  }
                },
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  label: const Text(
                    'EMAIL',
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],);
        });
  }

  Future setLaundry() async {
    final docUser =
        FirebaseFirestore.instance.collection('customerDetails').doc();

    docUser.set({
      'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
      'id': docUser.id,
      'name': '${firstnameController.text} ${lastnameController.text}',
      'contactnumber': contactController.text,
      'email': emailController.text,
      'address':
          '${streetController.text} ${brgyController.text}, ${municipalityController.text}, ${provinceController.text}, ${postalcodeController.text}',
      'schedule': schedule,
      'status': 'pending',
      'time': DateFormat('hh:mm a').format(datetimeNow).toString(),
      'date': DateFormat('yyyy-MM-dd').format(datetimeNow).toString(),
    });
  }
}
