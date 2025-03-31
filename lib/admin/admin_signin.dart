import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/admin/admin_dashboard.dart';
import 'package:sound_stage/organizer/org_signin.dart';
import 'package:sound_stage/services/auth.dart'; // Import the OrgLogin page

void main() {
  runApp(MaterialApp(home: AdminSignIn()));
}

class AdminSignIn extends StatefulWidget {
  @override
  _AdminSignInState createState() => _AdminSignInState();
}

class _AdminSignInState extends State<AdminSignIn> {
  bool _isPasswordVisible = false;
  bool _isAdmin = true;
  bool isLoading = false; // Track loading state

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _toggleSwitch(bool value) {
    if (!value) {
      // Navigate to OrgLogin when switched
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrgSignIn()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService().checkAdminLoggedIn(context: context);

    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => AdminDashboard()),
        (route) => false,
      );
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFFFFFFFF)],
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
                  "Switch to Organizer Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                value: _isAdmin,
                onChanged: _toggleSwitch,
                activeColor: Color(0xFF212121),
              ),
              Text(
                "Admin Login",
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
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Admin Email",
                          hintText: "Enter Email",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF212121),
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
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Admin Password",
                          hintText: "Enter password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF212121),
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
                              color: Color(0xFF212121),
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
                          backgroundColor: Color(0xFF212121),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  HapticFeedback.mediumImpact();
                                  await AuthService().adminSignIn(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                        child:
                            isLoading
                                ? SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth:
                                        3, // For a smooth Google-like animation
                                  ),
                                )
                                : Text(
                                  "Admin Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ],
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
