import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/pages/categories_event.dart';
import 'package:sound_stage/pages/detailpage.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? eventStream;
  late int userAge = 0;

  ontheload() async {
    eventStream = await DatabaseMethods().getallEvents();
    userAge = int.parse(await SharedPreferenceHelper().getUserAge() ?? "0");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
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

                return hasPassed || underAge
                    ? Container()
                    : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailPage(
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
                                  child: Image.asset(
                                    "images/event.jpg",
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
      body: SingleChildScrollView(
        // Wrap the whole body in a SingleChildScrollView
        child: Container(
          padding: EdgeInsets.only(top: 50.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe3e6ff), Color(0xffd5dbff), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(
                      "San Francisco, SH",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder<String?>(
                  future: SharedPreferenceHelper().getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        "Hello, ...",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Hello, Guest!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Text(
                        "Hello, ${snapshot.data}!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "There are events near your location",
                  style: TextStyle(
                    color: Color(0xff6351ec),
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.only(right: 20.0, left: 20),
                padding: EdgeInsets.only(left: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(
                        14,
                        14,
                        14,
                        0.23,
                      ), // Light shadow color with opacity
                      spreadRadius: 1, // How far the shadow spreads
                      blurRadius: 6, // The blur radius to make the shadow soft
                      offset: Offset(0, 2), // Position of the shadow (x, y)
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search_outlined),
                    border: InputBorder.none,
                    hintText: "Search for events",
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 125.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Categories (Jazz, Metal, Classical, etc.)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CategoriesEvent(eventCategory: "Jazz"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5, left: 20),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Container(
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/saxophone.png",
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "Jazz",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CategoriesEvent(eventCategory: "Metal"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Container(
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/guitar.png",
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "Metal",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CategoriesEvent(eventCategory: "Classical"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Container(
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/sitar.png",
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "Classical",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CategoriesEvent(eventCategory: "Rock Band"),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5, right: 20),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Container(
                            width: 125,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/drums.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "Rock Band",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Upcoming Events",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "see all",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              allEvents(), // List of events
            ],
          ),
        ),
      ),
    );
  }
}
