import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thomasian_post/screens/events/discover_events.dart';
import 'package:thomasian_post/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:thomasian_post/utils/theme_constants.dart';

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
        primaryColor: CustomTheme.primaryYellow,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: CustomTheme.appBarTheme,
        drawerTheme: CustomTheme.drawerTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: CustomTheme.primaryButtonStyle,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: SplashScreen(child: ViewEventList()),
    );
  }
}
