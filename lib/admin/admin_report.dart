import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/services/pdf/save_and_open_pdf.dart';
import 'package:sound_stage/services/pdf/simple_pdf_api.dart';

class ReportData {
  DateTime? _startDate;
  DateTime? _endDate;
  double _totalRevenue = 0.0;
  int _ticketsSold = 0;
  double _averageTicketPrice = 0.0;
  int _peakAttendance = 0;
  double _merchandiseRevenue = 0.0;

  ReportData(String? id) {
    _startDate = DateTime.now().subtract(const Duration(days: 31));
    _endDate = DateTime.now();
    _calculateReport();
  }

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  double get totalRevenue => _totalRevenue;
  int get ticketsSold => _ticketsSold;
  double get averageTicketPrice => _averageTicketPrice;
  int get peakAttendance => _peakAttendance;
  double get merchandiseRevenue => _merchandiseRevenue;

  set startDate(DateTime? value) {
    _startDate = value;
    _calculateReport();
  }

  set endDate(DateTime? value) {
    _endDate = value;
    _calculateReport();
  }

  // Simulate report calculation based on selected date range and concert
  Future<void> _calculateReport() async {
    final firestore = FirebaseFirestore.instance;
    final ticketRef =
        await firestore.collection('Tickets').where('EventDate').get();

    // Reset the values to avoid accumulation of previous data
    _totalRevenue = 0.0;
    _ticketsSold = 0;
    _merchandiseRevenue = 0.0;
    _peakAttendance = 0;

    if (ticketRef.docs.isNotEmpty) {
      // Simulate fetching data from Firestore
      for (var doc in ticketRef.docs) {
        String eventDateStr = doc['EventDate'];
        DateTime eventDate = DateFormat("dd-MM-yyyy").parse(eventDateStr);

        if (eventDate.isAfter(_startDate!) && eventDate.isBefore(_endDate!)) {
          // Accumulate revenue and merchandise revenue
          _totalRevenue += double.tryParse(doc['EventPrice']) ?? 0.0;
          _merchandiseRevenue += double.tryParse(doc['Total']) ?? 0.0;

          // Increment total tickets sold
          _ticketsSold += int.tryParse(doc['Number']) ?? 0;

          // Update peak attendance (find the maximum tickets sold for a single event)
          int eventAttendance = int.tryParse(doc['Number']) ?? 0;
          _peakAttendance =
              (_peakAttendance > eventAttendance)
                  ? _peakAttendance
                  : eventAttendance;
        }
      }

      // Calculate average ticket price
      _averageTicketPrice =
          _ticketsSold > 0 ? _totalRevenue / _ticketsSold : 0.0;
    }
  }
}

class AdminReport extends StatefulWidget {
  // const AdminReport({super.key});

  @override
  State<AdminReport> createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  late ReportData reportData;
  @override
  void initState() {
    super.initState();
    reportData = ReportData(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Generation",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DatePicker(
                        labelText: 'Start Date',
                        selectedDate: reportData.startDate,
                        onDateChanged: (DateTime? date) {
                          setState(() {
                            reportData.startDate = date;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DatePicker(
                        labelText: 'End Date',
                        selectedDate: reportData.endDate,
                        onDateChanged: (DateTime? date) {
                          setState(() {
                            reportData.endDate = date;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Report Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ReportCard(
                  title: 'Events Revenue',
                  value: NumberFormat.currency(
                    locale: 'en_IN',
                  ).format(reportData.totalRevenue),
                  icon: Icons.currency_rupee_sharp,
                ),
                const SizedBox(height: 16),
                ReportCard(
                  title: 'Tickets Sold',
                  value: reportData.ticketsSold.toString(),
                  icon: Icons.confirmation_number,
                ),
                const SizedBox(height: 16),
                ReportCard(
                  title: 'Average Ticket Price',
                  value: NumberFormat.currency(
                    locale: 'en_IN',
                  ).format(reportData.averageTicketPrice),
                  icon: Icons.money_rounded,
                ),
                const SizedBox(height: 16),
                ReportCard(
                  title: 'Peak Attendance',
                  value: reportData.peakAttendance.toString(),
                  icon: Icons.groups,
                ),
                const SizedBox(height: 16),
                ReportCard(
                  title: 'Total Revenue',
                  value: NumberFormat.currency(
                    locale: 'en_IN',
                  ).format(reportData.merchandiseRevenue),
                  icon: Icons.control_point_duplicate_sharp,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                final tablePdf = await SimplePdfApi.generateReportForAdmin(
                  reportData.startDate!,
                  reportData.endDate!,
                );
                SaveAndOpenDocument.openPdf(tablePdf);
              },
              child: const Icon(Icons.download),
            ),
          ),
        ],
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const DatePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          onDateChanged(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('MMMM d, y').format(selectedDate!)
                  : 'Select Date',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ReportCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(value, style: const TextStyle(fontSize: 24)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
