import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sound_stage/services/auth.dart';
import 'package:sound_stage/services/cloudinary_service.dart';

class OrgSignUp extends StatefulWidget {
  @override
  _OrgSignUpState createState() => _OrgSignUpState();
}

class _OrgSignUpState extends State<OrgSignUp> {
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _orgEmailController = TextEditingController();
  final TextEditingController _orgPasswordController = TextEditingController();
  final TextEditingController _orgConfirmPasswordController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF6A11CB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AppBar-like Content in Body, Fixed at the Top
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 25),
                      color: Colors.white,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context); // Navigate back
                      },
                    ),
                    SizedBox(width: 25),
                    Text(
                      "Create Organizer Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  selectedImage == null
                                      ? AssetImage('images/profile.png')
                                      : FileImage(
                                        selectedImage!,
                                      ), // Static image
                              backgroundColor: Colors.white,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child:
                                    selectedImage == null
                                        ? Icon(
                                          Icons.add_a_photo,
                                          color: Color(0xFF2575FC),
                                          size: 20,
                                        )
                                        : Icon(
                                          Icons.edit,
                                          color: Color(0xFF2575FC),
                                          size: 20,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                    _buildTextField(
                      label: "Organization Name",
                      icon: Icons.business,
                      controller: _orgNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an organization name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Email Address",
                      icon: Icons.email,
                      controller: _orgEmailController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Password",
                      icon: Icons.lock,
                      controller: _orgPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Confirm Password",
                      icon: Icons.lock,
                      controller: _orgConfirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    // Create Profile Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          HapticFeedback.mediumImpact();

                          if (_orgPasswordController.text !=
                              _orgConfirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          String? profileurl;
                          if (selectedImage != null) {
                            profileurl = await uploadtoCloudinary(
                              selectedImage,
                            );
                          }
                          AuthService().registerOrg(
                            context: context,
                            orgName: _orgNameController.text,
                            orgEmail: _orgEmailController.text,
                            orgPassword: _orgPasswordController.text,
                            orgPhone: "",
                            orgAddress: "",
                            orgWebsite: "",
                            orgFacebook: "",
                            orgImage: selectedImage == null ? null : profileurl,
                          );
                          setState(() {
                            _orgNameController.clear();
                            _orgEmailController.clear();
                            _orgPasswordController.clear();
                            selectedImage = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2B2B2B),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 3,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: Text('Sign Up', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    required TextEditingController? controller,
  }) {
    return Material(
      elevation: 5,
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.black87, width: 2),
          ),
        ),
      ),
    );
  }
}
