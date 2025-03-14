import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/organizer/org_event_detail.dart';
import 'package:sound_stage/organizer/ticket_data.dart';
import 'package:sound_stage/organizer/upload_event.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class ViewEvents extends StatefulWidget {
  bool? manage;
  ViewEvents({required this.manage});

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  Stream? eventStream;
  String? id;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getOrganizerId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    eventStream = await DatabaseMethods().getEventByOrganizerId(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  int selectedIndex = 0;
  final List<String> filters = ["All", "Active", "Completed", "Upcoming"];

  Widget allBookings() {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        // Filter events based on the selected filter
        var filteredEvents =
            snapshot.data.docs.where((ds) {
              // Parse the date and time fields separately
              String dateString = ds["Date"]; // e.g., "14-03-2025"
              String timeString = ds["Time"]; // e.g., "10:00 AM"

              // Remove non-breaking spaces and trim any leading/trailing spaces
              timeString =
                  timeString
                      .replaceAll(RegExp(r'\s+'), ' ')
                      .trim(); // Remove unwanted spaces and trim

              // First, parse the date in dd-MM-yyyy format
              DateTime eventDate = DateFormat('dd-MM-yyyy').parse(dateString);

              // Then, parse the time in 12-hour format (hh:mm a)
              DateTime eventTime;
              try {
                eventTime = DateFormat('hh:mm a').parse(timeString);
              } catch (e) {
                return false; // Skip event if time parsing fails
              }

              // Combine date and time
              DateTime eventDateTime = DateTime(
                eventDate.year,
                eventDate.month,
                eventDate.day,
                eventTime.hour,
                eventTime.minute,
              );

              DateTime currentDateTime = DateTime.now();

              switch (selectedIndex) {
                case 1: // Active filter
                  return eventDateTime.isBefore(
                        currentDateTime.add(Duration(days: 1)),
                      ) &&
                      eventDateTime.isAfter(
                        currentDateTime.subtract(Duration(days: 1)),
                      );
                case 2: // Completed filter
                  return eventDateTime.isBefore(
                    currentDateTime.subtract(Duration(days: 1)),
                  );
                case 3: // Upcoming filter
                  return eventDateTime.isAfter(currentDateTime);
                default: // All events
                  return true;
              }
            }).toList();

        return Expanded(
          child: ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = filteredEvents[index];
              return BookingCard(
                manage: widget.manage!,
                eventId: ds["EventId"],
                ageAllowed: ds["AgeAllowed"],
                category: ds["Category"],
                date: ds["Date"],
                details: ds["Details"],
                location: ds["Location"],
                name: ds["Name"],
                price: ds["Price"],
                image: ds["Image"],
                time: ds["Time"],
                approvalStatus: ds["EventApproved"],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffede9ff),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    filters.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String text = entry.value;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            selectedIndex =
                                idx; // Set the filter to the selected filter index
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selectedIndex == idx
                                    ? Color(0xff6351ec)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  selectedIndex == idx
                                      ? Color(0xff6351ec)
                                      : Color(0xFF9489E5),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  selectedIndex == idx
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            allBookings(),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String eventId;
  final String ageAllowed;
  final String category;
  final String date;
  final String details;
  final String location;
  final String name;
  final String price;
  final String time;
  final bool manage;
  final bool approvalStatus;
  final String image;

  const BookingCard({
    required this.eventId,
    required this.ageAllowed,
    required this.category,
    required this.date,
    required this.details,
    required this.location,
    required this.name,
    required this.price,
    required this.time,
    required this.manage,
    required this.approvalStatus,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    var eventDateTime = DateFormat('yyyy-MM-dd HH:mm').parse('$date $time');
    var currentDateTime = DateTime.now();

    // Check if there are tickets and the event is in the future
    bool showLiveBadge = eventDateTime.isAfter(currentDateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          if (manage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrgViewEvent(eventId: eventId),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TicketData(
                      eventId: eventId,
                      eventName: name,
                      eventDate: date,
                      eventTime: time,
                      eventImage: image,
                    ),
              ),
            );
          }
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image at the top with date overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // White background container with date overlay
                  Positioned(
                    top: 10,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Border radius added
                      ),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Border radius added
                      ),
                      child:
                          showLiveBadge ? BlinkingLiveBadge() : UpcomingBadge(),
                    ),
                  ),
                ],
              ),
              // Card details below the image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking Name and Age Allowed in the same row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        // Age allowed displayed in the same row with icon
                        Row(
                          children: [
                            Icon(Icons.person, size: 20, color: Colors.red),
                            SizedBox(width: 5),
                            Text(
                              '$ageAllowed+',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Price and Age Allowed (moved ageAllowed to name row)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              size: 20,
                              color: Colors.green,
                            ),
                            SizedBox(width: 5),
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Date and Time
                    Row(
                      children: [
                        Icon(Icons.date_range, size: 20, color: Colors.orange),
                        SizedBox(width: 5),
                        Text(date, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 20, color: Colors.purple),
                        SizedBox(width: 5),
                        Text(time, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Details section
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        details,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (manage && approvalStatus)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => UploadEvent(
                                        eventId: eventId,
                                        edit: true,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    if (approvalStatus == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Event approval pending',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlinkingLiveBadge extends StatefulWidget {
  @override
  _BlinkingLiveBadgeState createState() => _BlinkingLiveBadgeState();
}

class _BlinkingLiveBadgeState extends State<BlinkingLiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(_controller.value),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Live',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class UpcomingBadge extends StatefulWidget {
  @override
  _UpcomingBadgeState createState() => _UpcomingBadgeState();
}

class _UpcomingBadgeState extends State<UpcomingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Blinking duration
    )..repeat(reverse: true); // Repeats the animation back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Animated background color and text opacity (blinking effect)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(
                  _controller.value,
                ), // Blinking effect on background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Upcoming',
                style: TextStyle(
                  color: Colors.white.withOpacity(
                    _controller.value,
                  ), // Blinking effect on text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
