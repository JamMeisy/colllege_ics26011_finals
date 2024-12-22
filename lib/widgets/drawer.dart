import 'package:flutter/material.dart';
import 'package:thomasian_post/screens/events/discover_events.dart';
import 'package:thomasian_post/screens/events/my_events.dart';
import 'package:thomasian_post/screens/profile.dart';
import 'package:thomasian_post/screens/about.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.deepPurple,
              size: 24,
            ),
            title: Text(
              'Discover',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ViewEventList())),
          ),
          ListTile(
            leading: Icon(
              Icons.bookmarks,
              color: Colors.deepPurple,
              size: 22,
            ),
            title: Text(
              'My Events',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EventsPage())),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.deepPurple,
              size: 24,
            ),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfilePage())),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.deepPurple,
              size: 24,
            ),
            title: Text(
              'About',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AboutPage())),
          ),
        ],
      ),
    );
  }
}
