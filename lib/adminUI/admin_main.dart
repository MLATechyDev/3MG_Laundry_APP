import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/adminUI/pages/account_logs.dart';
import 'package:laundryapp/adminUI/pages/complete_laundry.dart';
import 'package:laundryapp/adminUI/pages/laudry_request.dart';
import 'package:laundryapp/adminUI/pages/on_process.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final pages = [
    LaundryRequest(),
    OnProcess(),
    CompleteLaundry(),
    AccountLogs(),
  ];

  final getDate = DateTime.now();

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: index == 3
            ? Text(
                'LOGS',
                style: GoogleFonts.merriweather(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const Text(''),
      ),
      body: pages[index],
      drawer: navDrawer(context),
    );
  }

  Widget navDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() => Container(
        padding: const EdgeInsets.only(top: 50),
        color: Colors.teal,
        width: double.infinity,
        height: 200,
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  )),
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItems() => Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(
                Icons.view_list,
                size: 40,
              ),
              title: Row(
                children: [
                  const Text(
                    'LAUNDRY REQUEST ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  laundryRequest(),
                ],
              ),
              onTap: () {
                setState(() {
                  index = 0;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.local_laundry_service,
                size: 40,
              ),
              title: const Text(
                'ON PROCESS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.check_circle,
                size: 40,
              ),
              title: const Text(
                'COMPLETE LAUNDRY',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 2;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.list_alt,
                size: 40,
              ),
              title: const Text(
                'LOGS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 3;
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 200,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                size: 40,
              ),
              title: const Text(
                'LOG OUT',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final docUser =
                    FirebaseFirestore.instance.collection('loginLogs').doc();

                await docUser.set({
                  'id': docUser.id,
                  'email': FirebaseAuth.instance.currentUser!.email,
                  'status': 'logout',
                  'time': DateFormat('hh:mm a').format(getDate),
                  'date': DateFormat('yyyy-MM-dd').format(getDate),
                });
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      );

  Widget laundryRequest() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('customerDetails')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.requireData;
          return Text(
            data.size.toString(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          );
        });
  }
}
