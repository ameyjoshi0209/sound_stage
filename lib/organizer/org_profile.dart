import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sound_stage/services/auth.dart';
import 'package:sound_stage/services/cloudinary_service.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class OrganizerProfile extends StatefulWidget {
  @override
  _OrganizerProfileState createState() => _OrganizerProfileState();
}

class _OrganizerProfileState extends State<OrganizerProfile> {
  String? id, imageUrl;
  bool _isPasswordVisible = false; // Track password visibility
  bool isLoading = false;

  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _orgEmailController = TextEditingController();
  final TextEditingController _orgPhoneController = TextEditingController();
  final TextEditingController _orgPasswordController = TextEditingController();
  final TextEditingController _orgAddressController = TextEditingController();
  final TextEditingController _orgWebsiteController = TextEditingController();
  final TextEditingController _orgFacebookController = TextEditingController();

  // Fetch the organizer data from SharedPreferences or database
  getthesharedpref() async {
    id = await SharedPreferenceHelper().getOrganizerId();
    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getOrganizerData() async {
    DocumentSnapshot orgDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (orgDoc.exists) {
      _orgEmailController.text = orgDoc['orgemail'];
      _orgPhoneController.text = orgDoc['orgphone'];
      _orgNameController.text = orgDoc['orgname'];
      _orgAddressController.text = orgDoc['orgaddress'];
      _orgWebsiteController.text = orgDoc['orgwebsite'];
      _orgFacebookController.text = orgDoc['orgfacebook'];
      _orgPasswordController.text = orgDoc['orgpassword'];
      imageUrl = orgDoc['orgimage'];
      setState(() {});
    }
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    await getOrganizerData();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _orgEmailController.dispose();
    _orgPhoneController.dispose();
    _orgPasswordController.dispose();
    _orgAddressController.dispose();
    _orgWebsiteController.dispose();
    _orgFacebookController.dispose();
    super.dispose();
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
              Colors.deepPurple.shade400, // Blue
              Colors.black87, // White
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context); // Navigate back
                    },
                  ),
                  Text(
                    "Organizer Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showLogoutWarning(context);
                    },
                    icon: Icon(Icons.logout),
                    color: Colors.red,
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
                    selectedImage == null
                        ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  imageUrl == null
                                      ? AssetImage('images/profile.png')
                                      : NetworkImage(imageUrl!),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )
                        : Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(selectedImage!),
                            backgroundColor: Colors.blue,
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
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
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
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  SharedPreferenceHelper().saveOrganizerId(id!);
                                  SharedPreferenceHelper().saveOrganizerEmail(
                                    _orgEmailController.text,
                                  );
                                  SharedPreferenceHelper().saveOrganizerName(
                                    _orgNameController.text,
                                  );
                                  SharedPreferenceHelper()
                                      .saveOrganizerPassword(
                                        _orgPasswordController.text,
                                      );
                                  String? profileurl;

                                  if (imageUrl == null &&
                                      selectedImage != null) {
                                    profileurl = await uploadtoCloudinary(
                                      selectedImage,
                                    );
                                  } else {
                                    if (selectedImage != null) {
                                      await deleteFromCloudinary(imageUrl!);
                                      profileurl = await uploadtoCloudinary(
                                        selectedImage,
                                      );
                                    } else {
                                      profileurl = imageUrl;
                                    }
                                  }
                                  Map<String, dynamic> organizerInfoMap = {
                                    "orgname": _orgNameController.text,
                                    "orgemail": _orgEmailController.text,
                                    "orgpassword": _orgPasswordController.text,
                                    "orgphone": _orgPhoneController.text,
                                    "orgaddress": _orgAddressController.text,
                                    "orgwebsite": _orgWebsiteController.text,
                                    "orgfacebook": _orgFacebookController.text,
                                    "orgimage": profileurl,
                                    "role": "organizer",
                                    "orgid": id,
                                  };

                                  await DatabaseMethods()
                                      .addOrganizerDetail(organizerInfoMap, id!)
                                      .then(
                                        (value) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Organizer data updated successfully!",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                          );
                                          ontheload(); // Reload the data
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        onError: (error) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                "Failed to upload data. Please try again.",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.deepPurple,
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
                        child:
                            isLoading
                                ? SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2A2A2A),
                                    backgroundColor: Colors.deepPurple,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth:
                                        3, // For a smooth Google-like animation
                                  ),
                                )
                                : Text(
                                  'Update Profile',
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
    Widget? suffixIcon,
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
            borderSide: BorderSide(color: Color(0xFF292929), width: 2),
          ),
          suffixIcon:
              suffixIcon, // Add the suffixIcon for password visibility toggle
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
