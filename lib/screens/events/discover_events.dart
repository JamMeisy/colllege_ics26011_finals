import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/widgets/create_event_button.dart';
import 'package:thomasian_post/screens/events/view_event.dart';
import 'package:intl/intl.dart';

// Custom color scheme constants
class AppColors {
  static const Color primary = Color(0xFFFFD700); // Yellow
  static const Color secondary = Color(0xFF000000); // Black
  static const Color background = Color(0xFFFFFDF4); // Light cream
  static const Color cardBackground = Color(0xFFFFFFFF); // White
  static const Color accent = Color(0xFFFFC400); // Darker yellow
  static const Color textPrimary = Color(0xFF000000); // Black
  static const Color textSecondary = Color(0xFF666666); // Dark grey
}

class ViewEventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Thomasian Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: ApprovedEventList(),
      floatingActionButton: CreateEventButton(),
    );
  }
}

class ApprovedEventList extends StatelessWidget {
  String formatDate(String dateStr) {
    try {
      final date = DateFormat('MM/dd/yyyy').parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error loading events',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Trigger a rebuild
                    (context as Element).markNeedsBuild();
                  },
                  child: Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                  ),
                ),
              ],
            ),
          );
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'No events available',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.cardBackground,
          onRefresh: () async {
            // Trigger a rebuild
            (context as Element).markNeedsBuild();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(12.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;

              return Hero(
                tag: 'event-${documents[index].id}',
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
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
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['eventName'] ?? 'Untitled Event',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: AppColors.accent,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            data['venue'] ??
                                                'No venue specified',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  formatDate(data['date'] ?? ''),
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppColors.accent,
                              ),
                              SizedBox(width: 4),
                              Text(
                                data['time'] ?? 'Time not specified',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
