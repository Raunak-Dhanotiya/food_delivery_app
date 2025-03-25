import 'package:flutter/material.dart';
import 'dart:async';
import 'Login.dart'; // Login Page
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Login Page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    // Set data in Firestore
    setData();
  }

  void setData() {
    final db = FirebaseFirestore.instance;
    final userData = <String, String>{
      "name": "sudeep",
      "password": "sdfdfdfdf",
    };

    db.collection("customer")
        .doc("BUmByKesqSg5TaaJauHS")
        .set(userData)
        .then((_) => print("Document successfully written!"))
        .onError((e, _) => print("Error writing document: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/F1.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

