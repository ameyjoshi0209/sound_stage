import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool isLoading = false; // Track loading state

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
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
                  "images/signup.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unlock the',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'World of Music',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Book, Listen, and Enjoy Music with Us. We create a new way to enjoy music and for you to create unforgettable moments.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff6351ec),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
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
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmpasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
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
                            SizedBox(height: 50),
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
                                minimumSize: Size(
                                  double.infinity,
                                  55,
                                ), // Ensure the button is large enough
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        HapticFeedback.mediumImpact();
                                        await AuthService().signup(
                                          context: context,
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmpasswordController.text,
                                        );
                                        setState(() {
                                          isLoading =
                                              false; // Hide loading indicator
                                        });
                                      },
                              child:
                                  isLoading
                                      ? Center(
                                        child: SizedBox(
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
                                        ),
                                      )
                                      : Text(
                                        "Sign Up",
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
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(context, '/signin');
                                    },
                                    child: Text(
                                      'Sign In',
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
