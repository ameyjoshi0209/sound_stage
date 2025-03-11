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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            print('Barcode Found: ${barcode.rawValue}');
          }
          if (image != null) {
            String? barcode = barcodes.first.rawValue;
            final splitBarcode = barcode!.split('#');
            StreamBuilder(
              stream: await DatabaseMethods().getBookingsByUserId(
                splitBarcode[0],
              ),
              builder: (context, snapshot) {
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                DocumentSnapshot ds = querySnapshot.docs[0];
                if (snapshot.hasData) {
                  return AlertDialog(
                    title: Text(ds['CustomerName']),
                    content: Text(
                      'Event ID: ${splitBarcode[1]}\nBooking ID: ${splitBarcode[2]}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          FutureBuilder(
                            future: await DatabaseMethods().updateBookingStatus(
                              splitBarcode[0],
                              splitBarcode[1],
                              splitBarcode[2],
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Text('Booking Approved');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          }
        },
      ),
    );
  }
}
