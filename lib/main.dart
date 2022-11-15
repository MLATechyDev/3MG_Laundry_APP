import 'package:flutter/material.dart';
import 'package:laundryapp/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MainApp());
}

  final navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
   MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.teal),
      title: '3MG Laundry',
      home: MainPageApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPageApp extends StatefulWidget {
  const MainPageApp({super.key});

  @override
  State<MainPageApp> createState() => _MainPageAppState();
}

class _MainPageAppState extends State<MainPageApp> {
  @override
  Widget build(BuildContext context) {
    return const LoginVerification();
  }
}
