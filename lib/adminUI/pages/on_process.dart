import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryapp/adminUI/infos/request_info.dart';

class OnProcess extends StatefulWidget {
  const OnProcess({super.key});

  @override
  State<OnProcess> createState() => _OnProcessState();
}

class _OnProcessState extends State<OnProcess> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ON PROCESS',
            style: GoogleFonts.merriweather(
              textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'SORT',
            ),
            Tab(
              text: 'WASH',
            ),
            Tab(
              text: 'DRY',
            ),
            Tab(
              text: 'FOLD',
            ),
          ]),
        ),
        body: TabBarView(children: [
          toSort(),
          toWash(),
          toDry(),
          toFold(),
        ]),
      ),
    );
  }

  Widget toSort() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('status', isEqualTo: 'sort')
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
                        'There is no Laundry need to SORT',
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
                          color: Colors.teal.shade100,
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
                              uid: data.docs[index]
                                    ['uid'],
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

  Widget toWash() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('status', isEqualTo: 'wash')
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
                        'There is no Laundry need to WASH',
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
                          color: Colors.teal.shade100,
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
                                dataLaundryCost: data.docs[index]
                                    ['laundryCost'],
                                dataCharge: data.docs[index]['charge'],
                                dataTotal: data.docs[index]['total'],
                                uid: data.docs[index]
                                    ['uid'],
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

  Widget toDry() {
    return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('status', isEqualTo: 'dry')
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
                        'There is no Laundry need to DRY',
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
                          color: Colors.teal.shade100,
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
                                dataLaundryCost: data.docs[index]
                                    ['laundryCost'],
                                dataCharge: data.docs[index]['charge'],
                                dataTotal: data.docs[index]['total'],
                                uid: data.docs[index]
                                    ['uid'],
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

  Widget toFold() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customerDetails')
                .where('status', isEqualTo: 'fold')
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
                        'There is no Laundry need to FOLD',
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
                          color: Colors.teal.shade100,
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
                                dataLaundryCost: data.docs[index]
                                    ['laundryCost'],
                                dataCharge: data.docs[index]['charge'],
                                dataTotal: data.docs[index]['total'],
                                uid: data.docs[index]
                                    ['uid'],
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
