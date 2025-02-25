import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/pages/booking.dart';
import 'package:sound_stage/pages/home.dart';
import 'package:sound_stage/pages/user_profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late UserProfile profile;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    home = const Home();
    booking = const Booking();
    profile = UserProfile();
    pages = [home, booking, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.transparent,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          HapticFeedback.heavyImpact();
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white, size: 30),
          Icon(Icons.book, color: Colors.white, size: 30),
          Icon(Icons.person_outline, color: Colors.white, size: 30),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
