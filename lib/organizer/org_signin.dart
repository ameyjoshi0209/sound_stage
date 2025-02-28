import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/admin/admin_signin.dart';
import 'package:sound_stage/pages/signin.dart'; // Import the AdminLogin page

class OrgSignIn extends StatefulWidget {
  @override
  _OrgSignInState createState() => _OrgSignInState();
}

class _OrgSignInState extends State<OrgSignIn> {
  bool _isPasswordVisible = false;
  bool _isOrg = true; // Track if organization login is active

  void _toggleSwitch(bool value) {
    if (value) {
      // Navigate to AdminLogin when switched
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminSignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF6A11CB),
            ], // Black to Dark Purple
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text(
                  "Switch to Admin Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                value: !_isOrg,
                onChanged: _toggleSwitch,
                activeColor: Color(0xFFDF014F),
              ),
              Text(
                "Organizer's Login",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Enter your credentials to continue",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Organizer Username",
                          hintText: "Enter username",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFFDF014F),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Organizer Password",
                          hintText: "Enter password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFFDF014F),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFFDF014F),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Recovery Password",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB7086E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Organizer Sign In",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/signin',
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Switch to User Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
