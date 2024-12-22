import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thomasian_post/screens/events/my_events.dart';
import 'package:thomasian_post/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thomasian Post',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepPurple),
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.inter().fontFamily,
        useMaterial3: true,
      ),
      home: SplashScreen(child: MyEventsPage()),
    );
  }
}
