import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundryapp/adminUI/admin_main.dart';
import 'package:laundryapp/costumerUI/costumer_main.dart';
import 'package:laundryapp/loginpage.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {

  final Stream<QuerySnapshot> userPosition = FirebaseFirestore.instance
      .collection('userAuth')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: userPosition,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Text('Loading please wait!'),
              ),
            );
          }

          final data = snapshot.requireData;
          int index = 0;

         
            return data.docs[index]['authentication'] == 'admin'
                ? const AdminMain()
                : data.docs[index]['authentication'] == 'customer' ?
                     const CostumerMainPage()
                   : LoginVerification();  
                    
          
        },
      );
  }
}