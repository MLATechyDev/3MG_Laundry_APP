import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ClientAccountLogs extends StatefulWidget {
  const ClientAccountLogs({super.key});

  @override
  State<ClientAccountLogs> createState() => _ClientAccountLogsState();
}

class _ClientAccountLogsState extends State<ClientAccountLogs> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('loginLogs')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
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
                      'No Logs',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 3),
                        child: Container(
                          color: data.docs[index]['status'] == 'login'
                              ? Colors.green[200]
                              : Colors.red[200],
                          child: ListTile(
                            leading: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('PLEASE CONFIRM'),
                                            content: Row(
                                              children: const [
                                                Icon(
                                                  Icons.help,
                                                  size: 30,
                                                ),
                                                Text(
                                                    '  Are you sure want to delete this logs?')
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    final docUser =
                                                        FirebaseFirestore.instance
                                                            .collection(
                                                                'loginLogs')
                                                            .doc(data.docs[index]
                                                                ['id']);
                                                    docUser.delete();

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('YES',
                                                      style: TextStyle(
                                                          fontSize: 16))),
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('NO',
                                                      style: TextStyle(
                                                          fontSize: 16)))
                                            ],
                                          ));
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                )),
                            title: Text(
                              data.docs[index]['email'],
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            subtitle: data.docs[index]['status'] == 'login'
                                ? const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                : const Text(
                                    'LOG OUT',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.docs[index]['time'],
                                ),
                                Text(
                                  data.docs[index]['date'],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
          }),
    );
  }
}
