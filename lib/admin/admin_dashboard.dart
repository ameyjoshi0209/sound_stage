import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sound_stage/admin/admin_approve_org.dart';
import 'package:sound_stage/admin/admin_event_approvals.dart';
import 'package:sound_stage/admin/admin_manage_users.dart';
import 'package:sound_stage/admin/admin_report.dart';
import 'package:sound_stage/services/auth.dart';
import 'package:sound_stage/services/database.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Stream? getAllUsers;

  ontheload() async {
    getAllUsers = await DatabaseMethods().getAllUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF006AFF), Color(0xFF191919), // Blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TweenAnimationBuilder(
                    tween: IntTween(begin: 0, end: "Welcome, Admin".length),
                    duration: Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Text(
                        "Welcome, Admin".substring(0, value),
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Updated text color
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, size: 30, color: Colors.white),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showLogoutWarning(context);
                    },
                  ),
                ],
              ), // Blue color for icons
              SizedBox(height: 34),
              Text(
                "Event Insights",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Updated text color
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: getAllUsers,
                      builder: (context, snapshot) {
                        return _buildRollingNumberCard(
                          context,
                          "Total Users",
                          snapshot.hasData ? snapshot.data.docs.length : 0,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection("Event")
                              .snapshots(),
                      builder: (context, snapshot) {
                        int totalEvents =
                            snapshot.hasData
                                ? snapshot.data?.docs.length ?? 0
                                : 0;
                        return _buildRollingNumberCard(
                          context,
                          "Total Events",
                          totalEvents,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection("Tickets")
                            .snapshots(),
                    builder: (context, snapshot) {
                      int totalTickets =
                          snapshot.hasData
                              ? snapshot.data!.docs.fold(
                                0,
                                (total, doc) =>
                                    total + (int.parse(doc['Total'])),
                              )
                              : 0;
                      return Expanded(
                        child: _buildRollingNumberCard(
                          context,
                          "Total Collections",
                          totalTickets,
                          isCurrency: true,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                  StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection("Tickets")
                            .snapshots(),
                    builder: (context, snapshot) {
                      int soldTickets =
                          snapshot.hasData
                              ? snapshot.data!.docs.fold(
                                0,
                                (total, doc) =>
                                    total + (int.parse(doc['Number'])),
                              )
                              : 0;
                      return Expanded(
                        child: _buildRollingNumberCard(
                          context,
                          "Total Tickets Sold",
                          soldTickets,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                "Main Sections",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Updated text color
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  children: [
                    _buildSectionCard(
                      context,
                      "Manage Users",
                      Icons.person_pin_rounded,
                    ),
                    _buildSectionCard(
                      context,
                      "Reports",
                      Icons.bar_chart_rounded,
                    ),
                    _buildSectionCard(
                      context,
                      "Organizer Approvals",
                      Icons.person_add_alt_1_rounded,
                    ),
                    _buildSectionCard(
                      context,
                      "Event Approvals",
                      Icons.event_available_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRollingNumberCard(
    BuildContext context,
    String title,
    int endValue, {
    bool isCurrency = false,
  }) {
    return Card(
      color: Colors.white, // White background for cards
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: 8),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: endValue),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Text(
                  isCurrency ? "₹$value" : value.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Blue color for the number
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, IconData icon) {
    return Card(
      color: Colors.white, // White background for cards
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                switch (title) {
                  case "Organizer Approvals":
                    return AdminApproveOrg();
                  case "Manage Users":
                    return AdminManageProfiles();
                  case "Event Approvals":
                    return AdminApproveEvents();
                  case "Reports":
                    return AdminReport();
                  default:
                    return Scaffold(
                      appBar: AppBar(title: Text(title)),
                      body: Center(child: Text("Coming Soon!")),
                    );
                }
              },
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue), // Blue color for icons
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ), // Black text color
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log out?"),
          content: Text("Are you sure you want to log out of this account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                AuthService().adminSignOut(context: context);
              },
              child: Text(
                "Log Out",
                style: TextStyle(color: Color(0xFF006AFF)),
              ),
            ),
          ],
        );
      },
    );
  }
}
