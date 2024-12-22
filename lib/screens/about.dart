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
              'VenueBookingApp',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'VenueBookingApp is an application designed to help users book venues for various events. It provides a seamless experience for browsing, booking, and managing event venues.',
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
              name: 'Developer 1',
              imageUrl: 'assets/images/developer1.png',
            ),
            DeveloperInfo(
              name: 'Developer 2',
              imageUrl: 'assets/images/developer2.png',
            ),
            DeveloperInfo(
              name: 'Developer 3',
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