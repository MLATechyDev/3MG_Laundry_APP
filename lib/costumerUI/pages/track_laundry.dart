import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryapp/costumerUI/infos/laudry_details.dart';

class TrackLaundry extends StatefulWidget {
  const TrackLaundry({super.key});

  @override
  State<TrackLaundry> createState() => _TrackLaundryState();
}

class _TrackLaundryState extends State<TrackLaundry> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              'Your Laudry Status',
              style: GoogleFonts.merriweather(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('customerDetails')
                  .where('email',
                      isEqualTo:
                          FirebaseAuth.instance.currentUser!.email.toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.requireData;

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal.shade200,
                          ),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.docs[index]['time'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                                Text(
                                  data.docs[index]['date'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                            title: Text(
                              'Laundry ID: ${data.docs[index]['id']}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            subtitle: Text(
                              'Deliver to: ${data.docs[index]['name'].toString().toUpperCase()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'STATUS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                Text(
                                  data.docs[index]['status'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: data.docs[index]['status'] ==
                                              'pending'
                                          ? Colors.red
                                          : Colors.green),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return LaundryDetails(
                                  name: data.docs[index]['name'],
                                  id: data.docs[index]['id'],
                                  address: data.docs[index]['address'],
                                  status: data.docs[index]['status'],
                                  schedule: data.docs[index]['schedule'],
                                  time: data.docs[index]['time'],
                                  date: data.docs[index]['date'],
                                  contactnumber: data.docs[index]
                                      ['contactnumber'],
                                  dataLaundryCost:
                                      data.docs[index]['status'] != 'pending'
                                          ? data.docs[index]['laundryCost']
                                          : 'null',
                                  dataCharge:
                                      data.docs[index]['status'] != 'pending'
                                          ? data.docs[index]['charge']
                                          : 'null',
                                  dataTotal:
                                      data.docs[index]['status'] != 'pending'
                                          ? data.docs[index]['total']
                                          : 'null',
                                  whenCompletethis:
                                      data.docs[index]['status'] == 'completed'
                                          ? data.docs[index]['whenComplete']
                                          : 'null',
                                );
                              }));
                            },
                          ),
                        ),
                      );
                    });
              }),
        ),
      ],
    );
  }
}
