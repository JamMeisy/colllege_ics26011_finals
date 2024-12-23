import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:thomasian_post/screens/admin/admin_pending_events.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/screens/events/my_events.dart';

// For Admin View
class AdminViewEvent extends StatefulWidget {
  final String eventId;
  final bool isAdmin;

  const AdminViewEvent({Key? key, required this.eventId, required this.isAdmin})
      : super(key: key);

  @override
  _AdminViewEventState createState() => _AdminViewEventState();
}

class _AdminViewEventState extends State<AdminViewEvent> {
  late Map<String, dynamic> eventData;

  @override
  void initState() {
    super.initState();
    eventData = {};
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    try {
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('Bookings')
          .doc(widget.eventId)
          .get();

      setState(() {
        eventData = eventSnapshot.data() as Map<String, dynamic>;
      });
    } catch (e) {
      print('Error fetching event details: $e');
    }
  }

  Future<void> _updateEventState(String newState) async {
    try {
      await FirebaseFirestore.instance
          .collection('Bookings')
          .doc(widget.eventId)
          .update({'state': newState});

      // Reload event details after updating state
      await _fetchEventDetails();

      // Navigate back to the homepage and replace the current page
      Navigator.pop(context);
    } catch (e) {
      print('Error updating event state: $e');
    }
  }

  Future<String?> _getImageUrl(String? eventId) async {
    try {
      if (eventId != null) {
        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection('Bookings')
            .doc(eventId)
            .get();

        if (eventSnapshot.exists) {
          Map<String, dynamic> eventData =
              eventSnapshot.data() as Map<String, dynamic>;
          return eventData['imageURL'] as String?;
        } else {
          print('Document with event ID $eventId does not exist.');
        }
      }
      return null;
    } catch (e) {
      print('Error fetching poster URL: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      drawer: MyDrawer(),
      body: eventData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Check if imageUrl is not null before displaying the image
                    if (eventData['imageURL'] != null &&
                        eventData['imageURL'] != '')
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: PhotoViewGallery.builder(
                                  itemCount: 1,
                                  builder: (context, index) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider: NetworkImage(
                                          eventData['imageURL'] ?? ''),
                                    );
                                  },
                                  scrollPhysics: BouncingScrollPhysics(),
                                  backgroundDecoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  pageController: PageController(),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          height: 400,
                          width: double.infinity,
                          child: PhotoView(
                            imageProvider: NetworkImage(
                              eventData['imageURL'] ?? '',
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 16),
                    Text(
                      '${eventData['eventName']}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black38,
                        ),
                        Text(' ${eventData['venue']}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.black38,
                          size: 20,
                        ),
                        Text(
                          ' ${eventData['date']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.black38,
                        ),
                        Text(' ${eventData['time']}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                      ],
                    ),
                    SizedBox(height: 32),
                    if (widget.isAdmin)
                      Column(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                    side: BorderSide(color: Color(0xFFFFD700))
                                    // Adjust the radius as needed
                                    ),
                              ),
                            ),
                            onPressed: () {
                              // Accept booking
                              _updateEventState('approved');
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check, color: Colors.green),
                                    Text("  Accept",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                    side: BorderSide(color: Color(0xFFFFD700))
                                    // Adjust the radius as needed
                                    ),
                              ),
                            ),
                            onPressed: () {
                              // reject booking
                              _updateEventState('declined');
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close_rounded,
                                        color: Colors.red),
                                    Text("  Reject",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PendingEventsPage(),
                                ),
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_left,
                                    ),
                                    Text("  Go Back",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
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
}
