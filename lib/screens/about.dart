import 'package:flutter/material.dart';
import 'package:thomasian_post/widgets/drawer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thomasian Post',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Thomasian Post is a dedicated mobile app designed to keep the University of Santo Tomas (UST) community connected and informed. Catering to the unique needs of each college, the app centralizes all events, announcements, and updates across the university. From academic schedules to cultural festivities, Thomasian Post ensures that Thomasians never miss an important moment, fostering a stronger sense of community and engagement within UST.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Text(
              'Developers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DeveloperInfo(
              name: 'Jam Meisy F. Tan',
              imageUrl: 'assets/images/developer1.png',
            ),
            DeveloperInfo(
              name: 'Wilmargherix M. Castañeda',
              imageUrl: 'assets/profile/rix.jpg',
            ),
            DeveloperInfo(
              name: 'Raphael Angelo F. Dacayo',
              imageUrl: 'assets/images/developer3.png',
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String imageUrl;

  DeveloperInfo({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imageUrl),
          ),
          SizedBox(width: 16),
          Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}