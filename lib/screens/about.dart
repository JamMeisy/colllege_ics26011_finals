import 'package:flutter/material.dart';
import 'package:thomasian_post/widgets/drawer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Thomasian Post',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Thomasian Post is your one-stop hub for everything UST! From academic updates to cultural events, our app is designed to keep every Thomasian informed and connected. Whether you want to check the latest announcements or stay on top of your schedule, Thomasian Post ensures you never miss a beat. Experience a stronger sense of community with every tap.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 32),
              Text(
                'Meet the Developers',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              DeveloperInfo(
                name: 'Jam Meisy F. Tan',
                imageUrl: 'assets/images/jam.png',
              ),
              DeveloperInfo(
                name: 'Wilmargherix M. Castañeda',
                imageUrl: 'assets/images/rix.jpg',
              ),
              DeveloperInfo(
                name: 'Raphael Angelo F. Dacayo',
                imageUrl: 'assets/images/raph.JPG',
              ),
            ],
          ),
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
          Hero(
            tag: name,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(imageUrl),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Developer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
