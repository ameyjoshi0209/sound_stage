import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrTicket extends StatefulWidget {
  String? customerId;
  String? eventId;
  String? bookingId;
  QrTicket({
    required this.customerId,
    required this.eventId,
    required this.bookingId,
  });

  @override
  State<QrTicket> createState() => _QrTicketState();
}

class _QrTicketState extends State<QrTicket> {
  String? qrData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Ticket")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: PrettyQrView.data(
                data:
                    "${widget.customerId!}#${widget.eventId!}#${widget.bookingId!}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
