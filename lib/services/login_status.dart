import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thomasian_post/screens/create_event.dart';
import 'package:thomasian_post/screens/login_page.dart';

class LoginStatus extends StatelessWidget {
  const LoginStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CreateEvent();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
