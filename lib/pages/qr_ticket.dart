import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

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
}
