import 'package:flutter/material.dart';
import 'package:thomasian_post/screens/events/discover_events.dart';
import 'package:thomasian_post/screens/events/my_events.dart';
import 'package:thomasian_post/screens/admin/admin_pending_events.dart';
import 'package:thomasian_post/screens/profile.dart';
import 'package:thomasian_post/screens/about.dart';
import 'package:thomasian_post/utils/admin_utils.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<bool> _checkAdminStatus() async {
    return await AdminUtils.checkIfAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAdminStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading admin status'));
        } else {
          bool isAdmin = snapshot.data ?? false;
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
                      MaterialPageRoute(builder: (context) => MyEventsPage())),
                ),
                if (isAdmin)
                  ListTile(
                    leading: Icon(
                      Icons.pending,
                      color: Colors.deepPurple,
                      size: 24,
                    ),
                    title: Text(
                      'Pending Events',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => PendingEventsPage())),
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
      },
    );
  }
}
