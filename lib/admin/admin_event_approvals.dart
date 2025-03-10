import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/admin/admin_view_event.dart';
import 'package:sound_stage/services/database.dart';

class AdminApproveEvents extends StatefulWidget {
  @override
  State<AdminApproveEvents> createState() => _AdminApproveEventsState();
}

class _AdminApproveEventsState extends State<AdminApproveEvents> {
  Stream? eventStream;

  ontheload() async {
    eventStream = await DatabaseMethods().getallEvents();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  int selectedIndex = 0;
  final List<String> filters = ["All", "Active", "Completed", "Cancelled"];

  Widget allBookings() {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ds["EventApproved"] == true
                      ? Container()
                      : BookingCard(
                        eventid: ds["EventId"],
                        image: ds["Image"],
                        ageAllowed: ds["AgeAllowed"],
                        category: ds["Category"],
                        date: ds["Date"],
                        details: ds["Details"],
                        location: ds["Location"],
                        name: ds["Name"],
                        price: ds["Price"],
                        time: ds["Time"],
                      );
                },
              ),
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        // Add a gradient as the background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2575FC),
              Color(0xFFFFFFFF), // Slightly darker color for contrast
            ],
          ),
        ),
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
                            selectedIndex = idx;
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
                                    ? Color(0xFF212121)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  selectedIndex == idx
                                      ? Colors.transparent
                                      : Colors.white38,
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
  final String ageAllowed;
  final String category;
  final String date;
  final String details;
  final String location;
  final String name;
  final String price;
  final String time;
  final String eventid;
  final String image;

  const BookingCard({
    required this.ageAllowed,
    required this.category,
    required this.date,
    required this.details,
    required this.location,
    required this.name,
    required this.price,
    required this.time,
    required this.eventid,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      AdminViewEvent(eventId: eventid, viewMode: 'approve'),
            ),
          );
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
                            Icon(Icons.person, size: 20, color: Colors.orange),
                            SizedBox(width: 5),
                            Text(
                              ageAllowed + '+',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
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
                              Icons.attach_money,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseMethods().approveEvent(eventid);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
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
