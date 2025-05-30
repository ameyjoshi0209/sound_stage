import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/admin/admin_signin.dart';
import 'package:sound_stage/organizer/org_dash.dart';
import 'package:sound_stage/organizer/org_signup.dart';
import 'package:sound_stage/services/auth.dart'; // Import the AdminLogin page

class OrgSignIn extends StatefulWidget {
  @override
  _OrgSignInState createState() => _OrgSignInState();
}

class _OrgSignInState extends State<OrgSignIn> {
  bool _isPasswordVisible = false;
  bool _isOrg = true; // Track if organization login is active
  bool isLoading = false; // Track loading state

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService().checkOrgLoggedIn(context: context);

    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OrganizerDashboard(),
        ),
        (route) => false,
      );
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This ensures the layout adjusts when the keyboard is visible
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView
        child: Container(
          height: MediaQuery.of(context).size.height,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 50.0,
            ),
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
                SizedBox(height: 100), // Add some spacing
                Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Organizer Email",
                        hintText: "Enter email",
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
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Organizer Password",
                        hintText: "Enter password",
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFDF014F)),
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
                    SizedBox(height: 35),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB7086E),
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
                                HapticFeedback.lightImpact();
                                await AuthService().orgSignIn(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                setState(() {
                                  isLoading = false; // Hide loading indicator
                                });
                              },
                      child:
                          isLoading
                              ? Center(
                                child: SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth:
                                        3, // For a smooth Google-like animation
                                  ),
                                ),
                              )
                              : Text(
                                "Organizer Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Still not an organizer? ',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrgSignUp(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.21),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
