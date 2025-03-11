import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/pages/detailpage.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class CategoriesEvent extends StatefulWidget {
  String eventCategory;
  CategoriesEvent({required this.eventCategory});

  @override
  State<CategoriesEvent> createState() => _CategoriesEventState();
}

class _CategoriesEventState extends State<CategoriesEvent> {
  Stream? eventStream;
  late int userAge = 0;

  getontheload() async {
    eventStream = await DatabaseMethods().getEventCategories(
      widget.eventCategory,
    );
    userAge = int.parse(await SharedPreferenceHelper().getUserAge() ?? "0");

    setState(() {});
  }

  initState() {
    getontheload();
    super.initState();
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: eventStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Column(
              // Using Column instead of ListView
              children: List.generate(snapshot.data.docs.length, (index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                String inputDate = ds["Date"];
                DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(inputDate);
                String formattedDate = DateFormat('MMM, dd').format(parsedDate);
                DateTime currentDate = DateTime.now();
                bool hasPassed = currentDate.isAfter(parsedDate);
                bool underAge = false;

                if (userAge <= int.parse(ds['AgeAllowed'])) {
                  underAge = true;
                }

                return hasPassed || underAge || ds['EventApproved'] == false
                    ? Container()
                    : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailPage(
                                  eventid: ds["EventId"],
                                  ageAllowed: ds["AgeAllowed"],
                                  category: ds["Category"],
                                  date: ds["Date"],
                                  details: ds["Details"],
                                  image: ds["Image"],
                                  location: ds["Location"],
                                  name: ds["Name"],
                                  price: ds["Price"],
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20.0, left: 20.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 260,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                    left: 10.0,
                                  ),
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      formattedDate,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  ds["Name"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  "₹ " + ds["Price"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff6351ec),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                Icon(Icons.location_on),
                                Text(
                                  ds["Location"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.0),
                        ],
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
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 26),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.eventCategory,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 20),
          allEvents(),
        ],
      ),
    );
  }
}
