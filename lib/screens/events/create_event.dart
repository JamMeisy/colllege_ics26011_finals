import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thomasian_post/utils/theme_constants.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/screens/events/my_events.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay(hour: 16, minute: 0);
  TextEditingController _venueController = TextEditingController();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  TextEditingController _registerLinkController = TextEditingController();
  TextEditingController _imageLinkController = TextEditingController();

  bool showDatePicker = false;
  bool showTimePicker = false;
  bool showEndTimePicker = false;
  bool _isSubmitting = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;

        if (user != null) {
          String userId = user.uid;
          String userName = user.displayName ?? 'Unknown User';

          String formattedDate =
              DateFormat('MMMM dd, yyyy').format(selectedDate);

          Timestamp timestamp = Timestamp.now();

          setState(() {
            _isSubmitting = true;
          });

          DateTime selectedDateTimeStart = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );

          DateTime selectedDateTimeEnd = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            endTime.hour,
            endTime.minute,
          );

          String formattedStartTime =
              DateFormat('hh:mm a').format(selectedDateTimeStart);
          String formattedEndTime =
              DateFormat('hh:mm a').format(selectedDateTimeEnd);

          await _firestore.collection('Bookings').add({
            'eventName': _eventNameController.text,
            'eventDescription': _eventDescriptionController.text,
            'date': formattedDate,
            'startHour': selectedTime.hour,
            'startMinute': selectedTime.minute,
            'endHour': endTime.hour,
            'endMinute': endTime.minute,
            'venue': _venueController.text,
            'time': '$formattedStartTime - $formattedEndTime',
            'imageURL': _imageLinkController.text,
            'registerlink': _registerLinkController.text,
            'userId': userId,
            'userEmail': user.email,
            'state': 'pending',
            'timestamp': timestamp
          });

          _eventNameController.clear();
          _eventDescriptionController.clear();
          _registerLinkController.clear();
          _venueController.clear();
          _imageLinkController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event submitted successfully!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyEventsPage(),
            ),
          );
        } else {
          print('No user signed in.');
        }
      } catch (e) {
        print('Error submitting event: $e');
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _registerLinkController.dispose();
    _venueController.dispose();
    _imageLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDatePicker = false;
          showTimePicker = false;
          showEndTimePicker = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Event'),
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Name',
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _eventNameController,
                    decoration: CustomTheme.getInputDecoration('Event Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Event Description',
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _eventDescriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style:
                            TextStyle(fontSize: 12, color: Colors.deepPurple),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDatePicker = !showDatePicker;
                            showTimePicker = false;
                            showEndTimePicker = false;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showDatePicker)
                    SizedBox(
                      height: 180,
                      child: ScrollDateTimePicker(
                        itemExtent: 54,
                        infiniteScroll: true,
                        dateOption: DateTimePickerOption(
                          dateFormat: DateFormat('MMM dd, yyyy'),
                          minDate: DateTime(2020, 1, 1),
                          maxDate: DateTime(2040, 12, 31),
                          initialDate: selectedDate,
                        ),
                        onChange: (datetime) => setState(() {
                          selectedDate = datetime;
                        }),
                      ),
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.deepPurple),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showTimePicker = !showTimePicker;
                                  showDatePicker = false;
                                  showEndTimePicker = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${selectedTime.format(context)}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.deepPurple),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showEndTimePicker = !showEndTimePicker;
                                  showTimePicker = false;
                                  showDatePicker = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${endTime.format(context)}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showEndTimePicker)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showEndTimePicker = false;
                        });
                      },
                      child: SizedBox(
                        height: 180,
                        child: ScrollDateTimePicker(
                          itemExtent: 54,
                          infiniteScroll: true,
                          dateOption: DateTimePickerOption(
                            dateFormat: DateFormat('hh:mm a'),
                            minDate: DateTime(2000, 1, 1, 0, 0),
                            maxDate: DateTime(2000, 1, 1, 23, 59),
                            initialDate: DateTime(
                              2000,
                              1,
                              1,
                              endTime.hour,
                              endTime.minute,
                            ),
                          ),
                          onChange: (datetime) => setState(() {
                            endTime = TimeOfDay(
                              hour: datetime.hour,
                              minute: datetime.minute,
                            );
                          }),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  if (showTimePicker)
                    SizedBox(
                      height: 180,
                      child: ScrollDateTimePicker(
                        itemExtent: 54,
                        infiniteScroll: true,
                        dateOption: DateTimePickerOption(
                          dateFormat: DateFormat('hh:mm a'),
                          minDate: DateTime(2000, 1, 1, 0, 0),
                          maxDate: DateTime(2000, 1, 1, 23, 59),
                          initialDate: DateTime(
                            2000,
                            1,
                            1,
                            selectedTime.hour,
                            selectedTime.minute,
                          ),
                        ),
                        onChange: (datetime) => setState(() {
                          selectedTime = TimeOfDay(
                            hour: datetime.hour,
                            minute: datetime.minute,
                          );
                        }),
                      ),
                    ),
                  Text(
                    'Venue',
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _venueController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the venue';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Link to Register',
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _registerLinkController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Event Image Link',
                    style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _imageLinkController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: submitBooking,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        child: _isSubmitting
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: Colors.deepPurpleAccent,
                              )
                            : Text('Submit'),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyEventsPage(),
                          ),
                        );
                      },
                      child: Text('Go Back to My Events'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
