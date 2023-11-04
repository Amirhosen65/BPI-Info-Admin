import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:send_notice/ComplainBox.dart';
import 'package:send_notice/HomePage.dart';
import 'package:send_notice/result_Page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
