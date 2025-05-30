import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sound_stage/services/database.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String? customerId;
  String? bookingId;
  Stream<QuerySnapshot>? bookingStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                String barcode = barcodes.first.rawValue!;
                final splitBarcode = barcode.split('#');
                if (splitBarcode.length != 2) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid QR Code'),
                        content: Text(
                          'The QR code scanned is invalid. Please try with valid QR.',
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
                customerId = splitBarcode[0];
                bookingId =
                    splitBarcode[1]; // Fix the index here, assuming bookingId is at index 1.

                // Fetch the stream from the database
                bookingStream = await DatabaseMethods().getTicketsByCustomerId(
                  customerId!,
                );

                if (bookingStream != null) {
                  // Show a loading dialog until the stream provides data
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return StreamBuilder(
                        stream: bookingStream,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return AlertDialog(
                              title: Text('Loading...'),
                              content: SizedBox(
                                height: 400,
                                width: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
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
                            HapticFeedback.vibrate();
                            var bookingData = snapshot.data!.docs.first;
                            if (bookingData["Attended"] == false) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 16,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  height: 400,
                                  width: 350,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(
                                          bookingData['CustomerImage'],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        bookingData['CustomerName'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        bookingData['CustomerEmail'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Amount: \$${bookingData['Total']}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Total Attendees: ${bookingData['Number']}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed: () async {
                                          HapticFeedback.lightImpact();
                                          await DatabaseMethods()
                                              .updateTicketStatus(customerId!);
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          backgroundColor: Colors.blueAccent,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.verified_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Check In",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if (bookingData["Attended"]) {
                              return AlertDialog(
                                title: Text(
                                  'Already Checked In',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'This booking has already been checked in.',
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Close",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }
                            String timeString = bookingData['EventTime'];
                            String dateString = bookingData['EventDate'];
                            timeString =
                                timeString
                                    .replaceAll(RegExp(r'\s+'), ' ')
                                    .trim(); // Remove unwanted spaces and trim

                            // Parse the event date and time into DateTime
                            var eventDateTime = DateFormat(
                              'dd-MM-yyyy HH:mm a',
                            ).parse('$dateString $timeString');
                            var currentDateTime = DateTime.now();

                            // Check if the event is live
                            bool isLive = currentDateTime.isAfter(
                              eventDateTime.subtract(
                                const Duration(hours: 1),
                              ), // 1 hour buffer
                            );
                            if (!isLive) {
                              return AlertDialog(
                                title: Text(
                                  'Event Not Live',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'This event is not live yet. Please wait until the event starts.',
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Close",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                        },
                      );
                    },
                  );
                }
              }
            },
          ),
          // QR Scan Area with overlay
          Center(
            child: Container(
              height: 360,
              width: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.black26, // Make center clear
                        border: Border.all(color: Colors.purple, width: 6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
