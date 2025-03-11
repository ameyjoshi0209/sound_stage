import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff6351ec),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xff8071f2),
          primary: Color(0xff6351ec),
        ),
        scaffoldBackgroundColor: Color(0xffede9ff),
      ),
      home: Booking(),
    );
  }
}

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookingStream;
  String? id;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    bookingStream = await DatabaseMethods().getbookings(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  int selectedIndex = 0;
  final List<String> filters = ["All", "Active", "Completed", "Cancelled"];

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return BookingCard(
                    image: ds['Image'],
                    title: ds['Event'],
                    location: ds['Location'],
                    status: 'Paid',
                    buttonText: 'View Ticket',
                    amount: ds['Total'],
                    people: ds['Number'] + ' People',
                    date: ds['Date'],
                  );
                },
              ),
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffede9ff),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    filters.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String text = entry.value;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            selectedIndex = idx;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selectedIndex == idx
                                    ? Color(0xff6351ec)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  selectedIndex == idx
                                      ? Color(0xff6351ec)
                                      : Color(0xFF9489E5),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color:
                                  selectedIndex == idx
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            allBookings(),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String status;
  final String buttonText;
  final String amount;
  final String people;
  final String date;

  const BookingCard({
    required this.image,
    required this.title,
    required this.location,
    required this.status,
    required this.buttonText,
    required this.amount,
    required this.people,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Color(0xfff0ebff),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      image,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(location, style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.green),
                            SizedBox(width: 3),
                            Text(amount),
                            SizedBox(width: 10),
                            Icon(Icons.people, color: Colors.blue),
                            SizedBox(width: 3),
                            Text(people),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.orange),
                            SizedBox(width: 5),
                            Text(date),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 205, 199, 240),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: Color.fromARGB(255, 87, 66, 248),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff6351ec),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(color: Colors.white),
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
}
