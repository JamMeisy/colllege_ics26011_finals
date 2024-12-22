import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/services/login_status.dart';
import 'package:thomasian_post/screens/view_event.dart';

class ViewEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thomasian Posts'),
      ),
      drawer: MyDrawer(),
      body: DoubleBackToCloseApp(
        child: ApprovedEventList(),
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginStatus(),
            ),
          );
        },
        label: Text(
          'Book',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class ApprovedEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Bookings')
          .where('state', isEqualTo: 'approved')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewEvent(
                        eventId: documents[index].id,
                        eventName: data['eventName'],
                        description: data['eventDescription'],
                        date: data['date'],
                        time: data['time'],
                        venue: data['venue'],
                        link: data['registerlink'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['eventName'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            data['venue'] ?? '',
                            style: TextStyle(
                              color: Color(0xffadadad),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        data['date'] ?? '',
                        style:
                            TextStyle(fontSize: 14, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
