import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thomasian_post/widgets/create_event_button.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/utils/color_utils.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> bookings = [];
  bool isLoading = false;

  // Fetch events for the current user
  Future<void> _fetchMyEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        QuerySnapshot querySnapshot = await _firestore
            .collection('Bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();

        setState(() {
          bookings = querySnapshot.docs;
        });
      } else {
        print('No user signed in.');
        // Clear the bookings list when no user is signed in
        setState(() {
          bookings = [];
        });
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchMyEvents,
          child: ListView.builder(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            shrinkWrap: true,
            itemCount: bookings.isEmpty ? 1 : bookings.length + 1,
            itemBuilder: (context, index) {
              // Case 1: Not logged in
              if (_auth.currentUser == null) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Please log in to see your bookings',
                        style: TextStyle(color: Color(0xffadadad)),
                      ),
                    ],
                  ),
                );
              }
              // Case 2: Logged in without Events
              else if (bookings.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'No created events',
                        style: TextStyle(color: Color(0xffadadad)),
                      ),
                    ],
                  ),
                );
              }
              // Case 3: Logged in with Events
              else if (index < bookings.length) {
                Map<String, dynamic> data =
                    bookings[index].data() as Map<String, dynamic>;

                // Allows users to remove events via swiping
                return Dismissible(
                  key: Key(bookings[index].id),
                  confirmDismiss: (DismissDirection direction) async {
                    // Show a confirmation dialog before removing the event
                    bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                            "Are you sure you want to remove this booking?",
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                "Remove",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm) {
                      try {
                        await _firestore
                            .collection('Bookings')
                            .doc(bookings[index].id)
                            .delete();

                        // Remove the dismissed item from the list
                        setState(() {
                          bookings.removeAt(index);
                        });
                      } catch (e) {
                        print('Error deleting document: $e');
                      }
                    }

                    return confirm;
                  },

                  // Swipe to delete background
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete_sweep,
                      color: Colors.white,
                    ),
                  ),

                  // Actual event card
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          data['imageURL'] != null
                              ? Image.network(
                                  data['imageURL'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['eventName'] ?? '',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    data['venue'] ?? '',
                                    style: TextStyle(color: Color(0xffadadad)),
                                  ),
                                ],
                              ),
                              Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorUtils.getStatusBorderColor(
                                        data['state']),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  data['state']?.toUpperCase() ?? 'UNKNOWN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorUtils.getStatusBorderColor(
                                        data['state']),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
      floatingActionButton: CreateEventButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
