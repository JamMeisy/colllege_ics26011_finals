import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thomasian_post/screens/admin/admin_view_event.dart';
import 'package:thomasian_post/utils/admin_utils.dart';
import 'package:thomasian_post/utils/color_utils.dart';
import 'package:thomasian_post/widgets/drawer.dart';

class PendingEventsPage extends StatefulWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  State<PendingEventsPage> createState() => _PendingEventsPageState();
}

class _PendingEventsPageState extends State<PendingEventsPage> {
  bool isAdmin = false;

  Future<void> _checkAdminStatus() async {
    bool adminStatus = await AdminUtils.checkIfAdmin();
    setState(() {
      isAdmin = adminStatus;
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> bookings = [];
  bool isLoading = false;

  // Fetch all events for admins
  Future<void> _fetchAllEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Bookings')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        bookings = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Events'),
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchAllEvents,
          child: ListView.builder(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            shrinkWrap: true,
            itemCount: bookings.isEmpty ? 1 : bookings.length + 1,
            itemBuilder: (context, index) {
              // Case 1: No events to show
              if (bookings.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'No bookings to show',
                        style: TextStyle(color: Color(0xffadadad)),
                      ),
                    ],
                  ),
                );
              }
              // Case 2: Display all events
              else if (index < bookings.length) {
                var data = bookings[index].data() as Map<String, dynamic>;

                // Swipe to remove
                return Dismissible(
                  key: Key(bookings[index].id),
                  confirmDismiss: (DismissDirection direction) async {
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
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete_sweep,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminViewEvent(
                            eventId: bookings[index].id,
                            isAdmin: true,
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
    );
  }
}
