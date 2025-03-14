import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sound_stage/organizer/upload_event.dart';
import 'package:sound_stage/services/database.dart';

class OrgViewEvent extends StatefulWidget {
  String? eventId;
  OrgViewEvent({required this.eventId});

  @override
  State<OrgViewEvent> createState() => _OrgViewEventState();
}

class _OrgViewEventState extends State<OrgViewEvent> {
  Stream? eventStream;

  ontheload() async {
    eventStream = await DatabaseMethods().getEventById(widget.eventId!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Show loading while waiting for data
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // Handle errors
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text('No event data found!'),
          ); // Handle no data scenario
        }

        DocumentSnapshot ds = snapshot.data.docs[0];
        return Scaffold(
          body: Stack(
            children: [
              // Gradient background filling the entire screen
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade500,
                      Colors.purple.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Content inside the stack
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.network(
                        ds['Image'], // Use your own image URL
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Event Name with larger, bold typography
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        ds['Name'],
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Event Date and Time
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.amber.shade300,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ds['Date'] + ' ' + ds['Time'],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Event Location
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.amber.shade300),
                          const SizedBox(width: 8),
                          Text(
                            'Downtown Arena, City Center',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Event Description with elegant font style
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        ds['Details'],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Grid for Age Restriction, Category, and Price
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap:
                            true, // To avoid infinite height in GridView
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling in GridView
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            3, // Adjust aspect ratio for rectangular grid items
                        children: [
                          // Age Restriction
                          _buildInfoCard(
                            Icons.accessibility_new,
                            'Age Restriction',
                            ds['AgeAllowed'],
                          ),

                          // Category
                          _buildInfoCard(
                            Icons.category,
                            'Category',
                            ds['Category'],
                          ),

                          // Price
                          _buildInfoCard(
                            Icons.currency_rupee,
                            'Price',
                            '₹' + ds['Price'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (ds['EventApproved'] == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  backgroundColor: Colors.deepPurple,
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => UploadEvent(
                                            edit: true,
                                            eventId: widget.eventId!,
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit Event',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  backgroundColor: Colors.red.shade500,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Delete Event',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper function to create each grid item (age restriction, category, price)
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          SizedBox(width: 5),
          Icon(icon, color: Colors.black87, size: 30), // Icon as prefix
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: TextStyle(color: Colors.deepPurple, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
