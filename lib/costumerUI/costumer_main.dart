import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/costumerUI/infos/admin_message.dart';
import 'package:laundryapp/costumerUI/pages/client_acc_log.dart';
import 'package:laundryapp/costumerUI/pages/set_a_laundry.dart';
import 'package:laundryapp/costumerUI/pages/track_laundry.dart';

class CostumerMainPage extends StatefulWidget {
  const CostumerMainPage({super.key});

  @override
  State<CostumerMainPage> createState() => _CostumerMainPageState();
}

class _CostumerMainPageState extends State<CostumerMainPage> {
    final getDate = DateTime.now();
  final pages = [
    const SetALaundryPage(),
    const TrackLaundry(),
    ClientAccountLogs(),
  ];

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

         actions: [
          Stack(children: [
            bellIcon(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('adminMessage')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('isRead', isEqualTo: 'notread')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return bellIcon();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final data = snapshot.requireData;
                return Positioned(
                  right: 12,
                  bottom: 35,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor:
                        data.size != 0 ? Colors.red : Colors.transparent,
                  ),
                );
              },
            ),
          ]),
        ],
      ),
      endDrawer: endnavDrawer(context),
      drawer: navDrawer(context),
      body: pages[index],
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
        child:  Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,

                child: Icon(Icons.person,size: 50,color: Colors.white,)),
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
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(
                Icons.local_laundry_service,
                size: 40,
              ),
              title: const Text(
                'SET A LAUNDRY',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                Icons.dry_cleaning,
                size: 40,
              ),
              title: const Text(
                'CHECK LAUNDRY STATUS',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ), const Divider(
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
                  index = 2;
                });
                Navigator.pop(context);
              },
            ),
            
            const SizedBox(height: 200,),
             ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                size: 40,
              ),
              title: const Text(
                'LOG OUT',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () async{
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

      
  Widget endbuildHeader() => Container(
        padding: EdgeInsets.only(top: 50),
        color: Colors.teal,
        width: double.infinity,
        child: Container(
            child: Center(
          child: Text(
            'LAUNDRY MESSAGE',
            style: GoogleFonts.merriweather(
              textStyle: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        )),
      );

  Widget endnavDrawer(BuildContext context) {
    return Drawer(
      width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            endbuildHeader(),
            endbuildMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget endbuildMenuItems() => Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('adminMessage')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return bellIcon();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final data = snapshot.requireData;
            return ListView.builder(
                itemCount: data.size,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                        height: 60,
                        color: Colors.teal.shade200,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return AdminMessage(
                                id: data.docs[index]['id'],
                                message: data.docs[index]['message'],
                                time: data.docs[index]['time'],
                                date: data.docs[index]['date'],
                              );
                            }));
                          },
                          leading: data.docs[index]['isRead'] == 'notread'
                              ? const Icon(Icons.mail)
                              : const Icon(Icons.drafts),
                          title: const Text(
                            'MESSAGE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data.docs[index]['time']),
                              Text(data.docs[index]['date']),
                            ],
                          ),
                        )),
                  );
                });
          },
        ),
      );

        Widget bellIcon() {
    return Builder(builder: (context) {
      return IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: Icon(
            Icons.notifications,
            size: 30,
            color: Colors.white,
          ));
    });
  }
}
