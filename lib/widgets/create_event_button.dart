import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thomasian_post/screens/auth/login.dart';
import 'package:thomasian_post/screens/events/create_event.dart';

class CreateEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CreateEvent();
                } else {
                  return LoginPage();
                }
              },
            ),
          ),
        );
      },
      label: Text(
        'Event',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      icon: Icon(
        Icons.add,
        size: 25,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
