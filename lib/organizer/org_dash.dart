import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                      "Manage Participants",
                      Icons.people,
                    ),
                    _buildSectionCard(
                      context,
                      "Financial Reports",
                      Icons.attach_money,
                    ),
                    _buildSectionCard(context, "Upcoming Events", Icons.event),
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
        onTap: () {},
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
}
