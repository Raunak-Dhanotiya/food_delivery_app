import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/Splash_Screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MyApp()); // Run the main app after Firebase is initialized
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.senTextTheme(), // Apply Sen font globally
      ),
      home: SplashScreen(), // First screen
    );
  }
}
