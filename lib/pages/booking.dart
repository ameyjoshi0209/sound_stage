import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/pages/qr_ticket.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookingStream;
  String? id, name;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    bookingStream = await DatabaseMethods().getTicketsByCustomerId(id!);
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
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var filteredEvents =
            snapshot.data.docs.where((ds) {
              // Parse the date and time fields separately
              String dateString = ds["EventDate"]; // e.g., "14-03-2025"
              String timeString = ds["EventTime"]; // e.g., "10:00 AM"

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
                image: ds['EventImage'],
                title: ds['EventName'],
                location: ds['EventLocation'],
                amount: ds['Total'],
                people: ds['Number'] + ' People',
                date: ds['EventDate'],
                time: ds['EventTime'],
                customerId: id!,
                customerName: name!,
                bookingId: ds["BookingId"],
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
      appBar: AppBar(
        title: Text(
          "My Bookings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
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
  final String image;
  final String title;
  final String location;
  final String amount;
  final String people;
  final String date;
  final String time;
  final String customerId;
  final String bookingId;
  final String customerName;

  const BookingCard({
    required this.image,
    required this.title,
    required this.location,
    required this.amount,
    required this.people,
    required this.date,
    required this.time,
    required this.customerId,
    required this.bookingId,
    required this.customerName,
  });

  String formatDate(String date) {
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
    return DateFormat(
      'd, MMM yyyy',
    ).format(parsedDate); // Returns the date in "12, Dec 2023" format
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QrTicket(
                    customerId: customerId,
                    bookingId: bookingId,
                    eventName: title,
                    location: location,
                    eventDate: date,
                    customerName: customerName,
                    eventTime: time,
                  ),
            ),
          );
        },
        child: Card(
          color: Color(0xfff0ebff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          child: Column(
            children: [
              // Stack to overlay date on top of image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      image,
                      height: 190,
                      width: double.infinity, // Ensures image covers the width
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned date at the top-left corner
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                          0.5,
                        ), // Background color
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        formatDate(date), // Format the date
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Padding for spacing
              SizedBox(height: 15),
              // Data content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.redAccent.shade200,
                        ),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.currency_rupee_rounded, color: Colors.green),
                        SizedBox(width: 2),
                        Text(amount),
                        SizedBox(width: 15),
                        Icon(Icons.people, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(people),
                        SizedBox(width: 15),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 205, 199, 240),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Active",
                            style: TextStyle(
                              color: Color.fromARGB(255, 87, 66, 248),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
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
