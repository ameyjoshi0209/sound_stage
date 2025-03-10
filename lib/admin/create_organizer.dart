import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sound_stage/services/auth.dart';
import 'package:sound_stage/services/cloudinary_service.dart';

class AdminCreateOrg extends StatefulWidget {
  @override
  _AdminCreateOrgState createState() => _AdminCreateOrgState();
}

class _AdminCreateOrgState extends State<AdminCreateOrg> {
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _orgEmailController = TextEditingController();
  final TextEditingController _orgPhoneController = TextEditingController();
  final TextEditingController _orgPasswordController = TextEditingController();
  final TextEditingController _orgAddressController = TextEditingController();
  final TextEditingController _orgWebsiteController = TextEditingController();
  final TextEditingController _orgFacebookController = TextEditingController();

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
            colors: [
              Color(0xFF2575FC), // Blue
              Color(0xFFFFFFFF), // White
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar-like Content in Body, Fixed at the Top
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
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
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                      label: "Phone Number",
                      controller: _orgPhoneController,
                      icon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
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
                      label: "Organization Address",
                      icon: Icons.location_on,
                      controller: _orgAddressController,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Website URL",
                      icon: Icons.language,
                      controller: _orgWebsiteController,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: "Facebook Link (Optional)",
                      icon: Icons.facebook,
                      controller: _orgFacebookController,
                    ),
                    SizedBox(height: 20),
                    // Create Profile Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
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
                            orgPhone: _orgPhoneController.text,
                            orgAddress: _orgAddressController.text,
                            orgWebsite: _orgWebsiteController.text,
                            orgFacebook: _orgFacebookController.text,
                            orgImage: selectedImage == null ? null : profileurl,
                          );
                          setState(() {
                            _orgNameController.clear();
                            _orgEmailController.clear();
                            _orgPhoneController.clear();
                            _orgPasswordController.clear();
                            _orgAddressController.clear();
                            _orgWebsiteController.clear();
                            _orgFacebookController.clear();
                            selectedImage = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2B2B2B),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Create Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
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
          prefixIcon: Icon(icon, color: Colors.blue),
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
            borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
          ),
        ),
      ),
    );
  }
}
