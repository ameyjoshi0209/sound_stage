import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                returnImage: true,
              ),
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                if (barcodes.isNotEmpty) {
                  String barcode = barcodes.first.rawValue!;
                  final splitBarcode = barcode.split('#');
                  customerId = splitBarcode[0];
                  bookingId =
                      splitBarcode[2]; // Fix the index here, assuming bookingId is at index 1.

                  // Fetch the stream from the database
                  bookingStream = await DatabaseMethods().getBookingByUserId(
                    customerId!,
                    bookingId!,
                  );

                  // Once the stream is set, show the dialog
                  if (bookingStream != null) {
                    // Show a loading dialog until the stream provides data
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: bookingStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return AlertDialog(
                                title: Text('Loading...'),
                                content: CircularProgressIndicator(),
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
                              var bookingData = snapshot.data!.docs.first;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ), // Rounded corners
                                ),
                                elevation: 16,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  height: 360,
                                  width: 300,
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(
                                          bookingData['CustomerImage'],
                                        ), // Profile image
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
                                          StreamBuilder(
                                            stream: await DatabaseMethods()
                                                .updateBookingStatus(
                                                  customerId!,
                                                  bookingId!,
                                                ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  'Error: ${snapshot.error}',
                                                );
                                              } else {
                                                return Text(
                                                  'Booking status updated successfully.',
                                                );
                                              }
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor:
                                              Colors.blueAccent, // Button color
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.verified_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Verified",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
