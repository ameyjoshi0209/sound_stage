import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/services/database.dart';

class TicketEvent extends StatefulWidget {
  const TicketEvent({super.key});

  @override
  State<TicketEvent> createState() => _TicketEventState();
}

class _TicketEventState extends State<TicketEvent> {
  Stream? ticketStream;

  ontheload() async {
    ticketStream = await DatabaseMethods().getTickets();
    setState(() {});
  }

  initState() {
    ontheload();
    super.initState();
  }

  Widget allTickets() {
    return StreamBuilder(
      stream: ticketStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Column(
              children: List.generate(snapshot.data.docs.length, (index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                String inputDate = ds["Date"];
                DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(inputDate);
                String formattedDate = DateFormat('MMM, dd').format(parsedDate);
                DateTime currentDate = DateTime.now();
                bool hasPassed = currentDate.isAfter(parsedDate);

                return hasPassed
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                                    child: Image.asset(
                                      'images/profile.jpg',
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ds["Event"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              ds["Location"],
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Color(0xff6351ec),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              ds["Name"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.attach_money,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              ds["Total"],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 30),
                                            Icon(
                                              Icons.people,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              ds["Number"],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              color: Colors.orange,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              ds["Date"],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
              }),
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF6A11CB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 4.5),
                Text(
                  "Event Tickets",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: allTickets()),
          ],
        ),
      ),
    );
  }
}
