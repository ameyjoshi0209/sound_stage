import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:sound_stage/services/data.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class DetailPage extends StatefulWidget {
  String image, name, location, date, details, price, ageAllowed, category;
  DetailPage({
    required this.image,
    required this.name,
    required this.location,
    required this.date,
    required this.details,
    required this.price,
    required this.ageAllowed,
    required this.category,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? paymentIntent;
  int ticket = 1;
  int total = 0;

  String? email, id, name;

  @override
  void initState() {
    total = int.parse(widget.price);
    ontheload();
    super.initState();
  }

  ontheload() async {
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section (Fixed)
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 20),
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.image, // Use widget.image
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: const EdgeInsets.only(top: 40, left: 20),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.black54),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white70,
                                    ),
                                    Text(
                                      widget.date,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 19,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white70,
                                        ),
                                        Text(
                                          widget.location,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ],
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
                SizedBox(height: 20), // Additional space
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "About the event",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.details,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true, // To avoid infinite height in GridView
                    physics:
                        NeverScrollableScrollPhysics(), // Disable scrolling in GridView
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        3, // Adjust aspect ratio for rectangular grid items
                    children: [
                      // Age Restriction
                      _buildInfoCard(
                        Icons.accessibility_new,
                        'Age Restriction',
                        widget.ageAllowed,
                      ),

                      // Category
                      _buildInfoCard(
                        Icons.category,
                        'Category',
                        widget.category,
                      ),

                      // Price
                      _buildInfoCard(
                        Icons.attach_money,
                        'Price',
                        '₹ ${widget.price}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom section (fixed ticket selection, amount, and button)
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
              color: Color(0xFFE4D8FF),
              borderRadius: BorderRadius.circular(30),
            ),

            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Number of tickets",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(width: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              if (ticket > 1) {
                                total -= int.parse(widget.price);
                                ticket -= 1;
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "You can't buy less than 1 ticket",
                                      style: TextStyle(fontSize: 16.5),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            ticket.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              if (ticket < 8) {
                                total += int.parse(widget.price);
                                ticket += 1;
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "You can only buy 8 tickets at a time",
                                      style: TextStyle(fontSize: 16.5),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Text(
                                "+",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        "₹ $total",
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff6351ea),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            makePayment(total.toString());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff6351ea),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            "Buy Now",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'inr');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Flutter Stripe Store',
            ),
          )
          .then((value) {});
      displayPaymentSheet(amount);
    } catch (e) {
      print(e);
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
            Map<String, dynamic> bookingdetail = {
              "Number": ticket.toString(),
              "Total": total.toString(),
              "Event": widget.name,
              "Price": widget.price,
              "Image": widget.image,
              "Location": widget.location,
              "Date": widget.date,
              "Name": name,
              "Email": email,
              "ID": id,
            };
            await DatabaseMethods().addUserBooking(bookingdetail, id!).then((
              value,
            ) async {
              await DatabaseMethods().addAdminTickets(bookingdetail);
            });
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            Text("Payment Successful"),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
            paymentIntent = null;
          })
          .onError((error, stackTrace) {
            print("Error is :--> $error $stackTrace");
          });
    } on StripeException catch (e) {
      print("Error is :--> $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text("Cancelled")),
      );
    } catch (e) {
      print("Error is :--> $e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = int.parse(amount) * 100;
    return calculatedAmount.toString();
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(icon, color: Colors.black87, size: 30), // Icon as prefix
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: TextStyle(color: Colors.deepPurple, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
