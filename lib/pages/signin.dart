import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/organizer/org_signin.dart';
import 'package:sound_stage/pages/bottomnav.dart';
import 'package:sound_stage/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService().checkUserLoggedIn(context: context);

    if (isLoggedIn) {
      // If logged in, navigate to BottomNav immediately
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const BottomNav()),
        (route) => false,
      );
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/signin.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Experience the',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Music near you',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Immerse yourself in the world of music. Join us to discover and enjoy.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 55),
                        Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xff6351ec),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xff6351ec),
                                ),
                              ),
                            ),
                            SizedBox(height: 55),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2A2A2A),
                                side: BorderSide(
                                  color: Color(0xff6351ec),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                minimumSize: Size(double.infinity, 55),
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () async {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          isLoading =
                                              true; // Show loading indicator
                                        });
                                        await AuthService().signin(
                                          context: context,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                        setState(() {
                                          isLoading =
                                              false; // Hide loading indicator
                                        });
                                      },
                              child:
                                  isLoading
                                      ? SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                          strokeWidth:
                                              3, // For a smooth Google-like animation
                                        ),
                                      )
                                      : Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 20,
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
                                    'Don\'t have an account? ',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Color(0xff6351ec),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrgSignIn(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Organizing an event?',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}
