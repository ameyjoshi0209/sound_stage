import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/organizer/view_events.dart';
import 'package:sound_stage/services/database.dart';

class TicketData extends StatefulWidget {
  String? eventId;
  String? eventName;
  String? eventDate;
  String? eventTime;
  String? eventImage;
  TicketData({
    required this.eventId,
    this.eventName,
    this.eventDate,
    this.eventTime,
    this.eventImage,
  });

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
  Stream? ticketData;

  ontheload() async {
    ticketData = await DatabaseMethods().getTicketsByEventId(widget.eventId!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: ticketData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              ); // Show loading while waiting for data
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data. Please try again later.'),
              );
            }

            String timeString = widget.eventTime!;
            timeString =
                timeString
                    .replaceAll(RegExp(r'\s+'), ' ')
                    .trim(); // Remove unwanted spaces and trim

            // Parse the event date and time into DateTime
            var eventDateTime = DateFormat(
              'dd-MM-yyyy HH:mm a',
            ).parse('${widget.eventDate} $timeString');
            var currentDateTime = DateTime.now();

            // Check if the event is live
            bool isLive = currentDateTime.isAfter(
              eventDateTime.subtract(const Duration(hours: 1)), // 1 hour buffer
            );

            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Column(
                children: [
                  // Increased height to prevent clipping of overlapping cards
                  SizedBox(
                    height: 380, // Extra space to accommodate the overlap
                    child: Stack(
                      clipBehavior: Clip.none, // Allow overflow
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            widget.eventImage!,
                            width: double.infinity,
                            height: 750,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 150,
                          left: 16, // Moves it above the cards
                          child:
                              isLive
                                  ? currentDateTime.isBefore(
                                        eventDateTime.add(
                                          const Duration(hours: 24),
                                        ),
                                      )
                                      ? BlinkingLiveBadge()
                                      : CompletedBadge()
                                  : UpcomingBadge(),
                        ),
                        // ✅ Move title up so it's visible
                        Positioned(
                          top: 55, // Moves it above the cards
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.eventName!,
                                style: TextStyle(
                                  fontSize: 38,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${widget.eventDate!} ${widget.eventTime!}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ✅ Cards half inside the image
                        Positioned(
                          bottom: -60, // Half inside, half below the image
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: _infoCard(
                                  Icons.currency_rupee_rounded,
                                  'Sales',
                                  '0',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _infoCard(
                                  Icons.local_activity,
                                  'Tickets Sold',
                                  '0',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 80), // Adjusted for proper spacing
                        Text(
                          'Live Attendees',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Text(
                            'No tickets sold yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            double getTicketSales() {
              return snapshot.data.docs.fold(
                0,
                (total, doc) => total + double.parse(doc['Total']),
              );
            }

            int getTicketsSold() {
              return snapshot.data.docs.fold(
                0,
                (total, doc) => total + int.parse(doc['Number']),
              );
            }

            return Column(
              children: [
                // Increased height to prevent clipping of overlapping cards
                SizedBox(
                  height: 390, // Extra space to accommodate the overlap
                  child: Stack(
                    clipBehavior: Clip.none, // Allow overflow
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          widget.eventImage!,
                          width: double.infinity,
                          height: 750,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // ✅ Move title up so it's visible
                      Positioned(
                        top: 130, // Moves it above the cards
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.eventName!,
                              style: TextStyle(
                                fontSize: 38,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${widget.eventDate!} ${widget.eventTime!}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ✅ Cards half inside the image
                      Positioned(
                        bottom: -60, // Half inside, half below the image
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _infoCard(
                                Icons.currency_rupee_rounded,
                                'Sales',
                                getTicketSales().toStringAsFixed(2),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _infoCard(
                                Icons.local_activity,
                                'Tickets Sold',
                                getTicketsSold().toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80), // Adjusted for proper spacing
                      const Text(
                        'Attendees',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.only(top: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var ticket = snapshot.data.docs[index];
                          return ticket['Attended']
                              ? Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(
                                          ticket['CustomerImage'],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ticket['CustomerName'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            ticket['CustomerEmail'],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.people_alt_sharp,
                                                color: Colors.blue,
                                                size: 25,
                                              ),
                                              Text(
                                                ' x ${ticket['Number']}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${ticket['Total']}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4), // Enhanced shadow for depth
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
