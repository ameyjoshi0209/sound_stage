import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:sound_stage/services/pdf/save_and_open_pdf.dart';

class Ticket {
  final String evnetName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventPrice;
  final String eventNumberOfTickets;

  const Ticket({
    required this.evnetName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventPrice,
    required this.eventNumberOfTickets,
  });
}

class SimplePdfApi {
  static Future<File> generateTablePdf(
    DateTime startDate,
    DateTime endDate,
    String organizerId,
  ) async {
    final pdf = Document();
    final headers = [
      'Name',
      'Date',
      'Time',
      'Location',
      'Price',
      'Ticket Count',
    ];
    final firestore = FirebaseFirestore.instance;
    final ticketRef =
        await firestore.collection('Tickets').where('EventDate').get();
    final ticket = [];

    if (ticketRef.docs.isNotEmpty) {
      for (var doc in ticketRef.docs) {
        String eventDateStr = doc['EventDate'];
        DateTime eventDate = DateFormat("dd-MM-yyyy").parse(eventDateStr);
        if (eventDate.isAfter(startDate) && eventDate.isBefore(endDate)) {
          if (doc['OrganizerId'] != organizerId) {
            continue; // Skip if the event does not belong to the organizer
          }
          ticket.add(
            Ticket(
              evnetName: doc['EventName'],
              eventDate: doc['EventDate'],
              eventTime: doc['EventTime'],
              eventLocation: doc['EventLocation'],
              eventPrice: doc['EventPrice'],
              eventNumberOfTickets: doc['Number'],
            ),
          );
        }
      }
    }
    // final data = users.map((user) => [user.name, user.age]).toList();
    final data =
        ticket.map((ticket) {
          return [
            ticket.evnetName,
            ticket.eventDate,
            ticket.eventTime,
            ticket.eventLocation,
            ticket.eventPrice,
            ticket.eventNumberOfTickets,
          ];
        }).toList();
    pdf.addPage(
      Page(
        build:
            (context) => TableHelper.fromTextArray(
              data: data,
              headers: headers,
              cellAlignment: Alignment.center,
              tableWidth: TableWidth.max,
            ),
      ),
    );
    return SaveAndOpenDocument.savePdf(name: "table_pdf.pdf", pdf: pdf);
  }

  static Future<File> generateReportForAdmin(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = Document();
    final headers = [
      'Name',
      'Date',
      'Time',
      'Location',
      'Price',
      'Ticket Count',
    ];
    final firestore = FirebaseFirestore.instance;
    final ticketRef =
        await firestore.collection('Tickets').where('EventDate').get();
    final ticket = [];

    if (ticketRef.docs.isNotEmpty) {
      for (var doc in ticketRef.docs) {
        String eventDateStr = doc['EventDate'];
        DateTime eventDate = DateFormat("dd-MM-yyyy").parse(eventDateStr);
        if (eventDate.isAfter(startDate) && eventDate.isBefore(endDate)) {
          ticket.add(
            Ticket(
              evnetName: doc['EventName'],
              eventDate: doc['EventDate'],
              eventTime: doc['EventTime'],
              eventLocation: doc['EventLocation'],
              eventPrice: doc['EventPrice'],
              eventNumberOfTickets: doc['Number'],
            ),
          );
        }
      }
    }
    // final data = users.map((user) => [user.name, user.age]).toList();
    final data =
        ticket.map((ticket) {
          return [
            ticket.evnetName,
            ticket.eventDate,
            ticket.eventTime,
            ticket.eventLocation,
            ticket.eventPrice,
            ticket.eventNumberOfTickets,
          ];
        }).toList();
    pdf.addPage(
      Page(
        build:
            (context) => TableHelper.fromTextArray(
              data: data,
              headers: headers,
              cellAlignment: Alignment.center,
              tableWidth: TableWidth.max,
            ),
      ),
    );
    return SaveAndOpenDocument.savePdf(name: "table_pdf.pdf", pdf: pdf);
  }
}
