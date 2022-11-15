import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryapp/adminUI/infos/request_info.dart';

class LaundryRequest extends StatefulWidget {
  const LaundryRequest({super.key});

  @override
  State<LaundryRequest> createState() => _LaundryRequestState();
}

class _LaundryRequestState extends State<LaundryRequest> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'LAUNDRY REQUEST',
            style: GoogleFonts.merriweather(
              textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'DROP-OFF',
            ),
            Tab(
              text: 'PICK-UP',
            ),
            Tab(
              text: 'TO COLLECT',
            ),
          ]),
        ),
        body: TabBarView(children: [
          toDropOFF(),
          toPickUp(),
          toCollect(),
        ]),
      ),
    );
  }

  Widget toDropOFF() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('schedule', isEqualTo: 'dropoff')
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.requireData;

              return data.size == 0
                  ? const Center(
                      child: Text(
                        'There is no DROP-OFF request',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
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
                                'Name: ${data.docs[index]['name'].toString().toUpperCase()}',
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
                                  return RequestInfo(
                                    name: data.docs[index]['name'],
                                    id: data.docs[index]['id'],
                                    address: data.docs[index]['address'],
                                    status: data.docs[index]['status'],
                                    schedule: data.docs[index]['schedule'],
                                    time: data.docs[index]['time'],
                                    date: data.docs[index]['date'],
                                    contactnumber: data.docs[index]
                                        ['contactnumber'],
                                    uid: data.docs[index]['uid'],
                                  );
                                }));
                              },
                            ),
                          ),
                        );
                      });
            }),
      ),
    );
  }

  Widget toPickUp() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('schedule', isEqualTo: 'pickup')
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.requireData;

              return data.size == 0
                  ? const Center(
                      child: Text(
                        'There is no PICK-UP request',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
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
                            'Name: ${data.docs[index]['name'].toString().toUpperCase()}',
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
                                    color:
                                        data.docs[index]['status'] == 'pending'
                                            ? Colors.red
                                            : Colors.green),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return RequestInfo(
                                name: data.docs[index]['name'],
                                id: data.docs[index]['id'],
                                address: data.docs[index]['address'],
                                status: data.docs[index]['status'],
                                schedule: data.docs[index]['schedule'],
                                time: data.docs[index]['time'],
                                date: data.docs[index]['date'],
                                contactnumber: data.docs[index]
                                    ['contactnumber'],
                                uid: data.docs[index]['uid'],
                              );
                            }));
                          },
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }

  Widget toCollect() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('schedule', isEqualTo: 'pickup')
                .where('status', isEqualTo: 'accepted')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.requireData;

              return data.size == 0
                  ? const Center(
                      child: Text(
                        'There is no Laundry need to collect',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
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
                            'Name: ${data.docs[index]['name'].toString().toUpperCase()}',
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
                                    color:
                                        data.docs[index]['status'] == 'pending'
                                            ? Colors.red
                                            : Colors.green),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return RequestInfo(
                                name: data.docs[index]['name'],
                                id: data.docs[index]['id'],
                                address: data.docs[index]['address'],
                                status: data.docs[index]['status'],
                                schedule: data.docs[index]['schedule'],
                                time: data.docs[index]['time'],
                                date: data.docs[index]['date'],
                                contactnumber: data.docs[index]
                                    ['contactnumber'],
                                uid: data.docs[index]['uid'],
                              );
                            }));
                          },
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
