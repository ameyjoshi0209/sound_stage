import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sound_stage/services/database.dart';

class QrTicket extends StatefulWidget {
  final String? customerId;
  final String? bookingId;
  final String? customerName;
  final String? eventName;
  final String? location;
  final String? eventDate;
  final String? eventTime;

  QrTicket({
    required this.customerId,
    required this.bookingId,
    required this.customerName,
    required this.eventName,
    required this.location,
    required this.eventDate,
    required this.eventTime,
  });

  @override
  State<QrTicket> createState() => _QrTicketState();
}

class _QrTicketState extends State<QrTicket> {
  String? qrData;
  bool? showMessage;
  Stream? bookingStream;

  Future<void> checkStatus() async {
    DocumentSnapshot ds =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.customerId)
            .collection("booking")
            .doc(widget.bookingId)
            .get();

    if (ds.exists) {
      if (ds["Attended"] == false) {
        showMessage = true;
      }
    }
  }

  ontheload() async {
    bookingStream = await DatabaseMethods().getBookingByUserId(
      widget.customerId!,
      widget.bookingId!,
    );
    checkStatus();
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Column(
              children: [
                Text(
                  widget.eventName ?? "Event Name",
                  style: TextStyle(
                    fontSize: 43,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 27),
                    Text(
                      widget.location ?? "Venue Name",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd, MMM yyyy').format(
                        DateFormat('dd-MM-yyyy').parse(widget.eventDate!),
                      ),
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.eventTime!,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.orange,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Customer name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Ticket Holder",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.customerName ?? "Customer Name",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // QR Code Container
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: PrettyQrView.data(
                      data: "${widget.customerId!}#${widget.bookingId!}",
                    ),
                  ),
                ),
                if (showMessage == true)
                  StreamBuilder(
                    stream: bookingStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return AlertDialog(
                          title: Text('Loading...'),
                          content: SizedBox(
                            height: 400,
                            width: 300,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return AlertDialog(
                          title: Text('No Data'),
                          content: Text('No booking data found.'),
                        );
                      } else {
                        var bookingData = snapshot.data.docs[0];
                        if (bookingData["Attended"] == true) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _showScanDialog();
                          });
                          return Container();
                        }
                      }
                      return Container();
                    },
                  ),
                SizedBox(height: 30),
                // Booking ID
                Text(
                  "Booking ID: ${widget.bookingId ?? "Booking ID"}",
                  style: TextStyle(fontSize: 17, color: Colors.black87),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.black, size: 30),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context); // Close the screen
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the dialog
  // Function to show the dialog
  Future<dynamic> _showScanDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome to the Event!'),
          content: Text(
            'Hello ${widget.customerName ?? "Customer"},\n\n'
            'You have successfully checked in to the event: ${widget.eventName ?? "Event Name"}.\n'
            'Enjoy the event!',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
