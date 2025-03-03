import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sound_stage/organizer/ticket_event.dart';
import 'package:sound_stage/organizer/upload_event.dart';
import 'package:sound_stage/organizer/view_events.dart';
import 'package:sound_stage/services/auth.dart';

class OrganizerDashboard extends StatefulWidget {
  @override
  _OrganizerDashboardState createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF6A11CB),
            ], // Black to Purple Gradient
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
                children: [
                  Center(
                    child: Text(
                      "Organizer Dashboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showLogoutWarning(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 34),
              Text(
                "Event Insights",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildRollingNumberCard(
                      context,
                      "Total Collection",
                      15000,
                      isCurrency: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildRollingNumberCard(
                      context,
                      "Participants",
                      1200,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                "Main Sections",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
                    _buildSectionCard(context, "Post Events", Icons.add),
                    _buildSectionCard(
                      context,
                      "View Tickets",
                      Icons.event_seat,
                    ),
                    _buildSectionCard(
                      context,
                      "Financial Reports",
                      Icons.attach_money,
                    ),
                    _buildSectionCard(context, "Manage Events", Icons.event),
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
      color: Colors.black54,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(height: 8),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: endValue),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Text(
                  isCurrency ? "\$${value.toString()}" : value.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
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
      color: Colors.black54,
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                switch (title) {
                  case "Post Events":
                    return UploadEvent();
                  case "View Tickets":
                    return ViewEvents(manage: false);
                  case "Manage Events":
                    return ViewEvents(manage: true);
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
              Icon(icon, size: 40, color: Colors.purpleAccent),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
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
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                AuthService().orgSignOut(context: context);
              },
              child: Text(
                "Log Out",
                style: TextStyle(color: Color(0xff6351ec)),
              ),
            ),
          ],
        );
      },
    );
  }
}
