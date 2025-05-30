import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sound_stage/services/auth.dart';
import 'package:sound_stage/services/cloudinary_service.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  String? id, name, email, password, phone, age, image;

  bool isPasswordVisible = false;

  // Declare controllers at the class level
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isLoading = false; // Track loading state

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    password = await SharedPreferenceHelper().getUserPassword();
    phone = await SharedPreferenceHelper().getUserPhone();
    age = await SharedPreferenceHelper().getUserAge();
    image = await SharedPreferenceHelper().getUserImage();

    // Initialize the controllers with the retrieved values
    nameController.text = name ?? '';
    emailController.text = email ?? '';
    passwordController.text = password ?? '';
    phoneController.text = phone ?? '';
    ageController.text = age ?? '';
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  String formatDate(DateTime date) {
    return DateFormat(
      'd, MMM yyyy',
    ).format(date); // Returns the date in "12, Dec 2023" format
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd5dbff),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10),
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.black,
              size: 29,
              semanticLabel: 'Logout',
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showLogoutWarning(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Profile Picture with Camera Icon
              Stack(
                children: [
                  selectedImage == null
                      ? GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              image == null || image == "none"
                                  ? AssetImage('images/profile.png')
                                  : NetworkImage(image!), // Static image
                        ),
                      )
                      : CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(selectedImage!),
                      ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xff6351ec),
                      child:
                          selectedImage == null
                              ? Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 18,
                              )
                              : Icon(Icons.edit, color: Colors.black, size: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),

              // Text Fields
              _buildTextField(nameController, Icons.person, "Full Name", ''),
              _buildTextField(emailController, Icons.email, "E-Mail", ''),
              _buildTextField(phoneController, Icons.phone, "Phone No", ''),
              _buildTextField(
                ageController,
                Icons.assignment_ind_outlined,
                "Age",
                '',
                isDate: true,
              ),
              _buildTextField(
                passwordController,
                Icons.lock,
                "Password",
                '',
                isPassword: true,
              ),

              SizedBox(height: 35),

              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            HapticFeedback.lightImpact();
                            setState(() {
                              isLoading = true;
                            });
                            // Update data in shared pref and database
                            SharedPreferenceHelper().saveUserEmail(
                              emailController.text,
                            );
                            SharedPreferenceHelper().saveUserName(
                              nameController.text,
                            );
                            SharedPreferenceHelper().saveUserPassword(
                              passwordController.text,
                            );
                            SharedPreferenceHelper().saveUserPhone(
                              phoneController.text,
                            );
                            SharedPreferenceHelper().saveUserAge(
                              ageController.text,
                            );
                            String? profileurl;
                            if (image == "none" && selectedImage != null) {
                              profileurl = await uploadtoCloudinary(
                                selectedImage,
                              );
                              await SharedPreferenceHelper().saveUserImage(
                                profileurl,
                              );
                            } else if (selectedImage != null) {
                              await deleteFromCloudinary(image!);
                              profileurl = await uploadtoCloudinary(
                                selectedImage,
                              );
                              SharedPreferenceHelper().saveUserImage(
                                profileurl,
                              );
                            } else {
                              profileurl = image;
                            }
                            Map<String, dynamic> userInfoMap = {
                              "name": nameController.text,
                              "email": emailController.text,
                              "password": passwordController.text,
                              "phone": phoneController.text,
                              "age": ageController.text,
                              "image": profileurl,
                              "userid": id,
                              "role": "customer",
                            };

                            await DatabaseMethods()
                                .addUserDetail(userInfoMap, id!)
                                .then(
                                  (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Colors.green.shade600,
                                        content: Text(
                                          "User updated successfully!",
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  onError: (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Failed to upload event. Please try again.",
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ),
                                    );
                                  },
                                );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6351ec),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
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
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Joined On: ${formatDate(FirebaseAuth.instance.currentUser!.metadata.creationTime!)}",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        id?.substring(0, 21) ?? '',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),

                  // Delete Button
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        _showDeleteWarning(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x89F44336),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(width: 2, color: Color(0xffF44336)),
                        ),
                      ),
                      child: Text("Delete", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, // Accept the controller as a parameter
    IconData icon,
    String label,
    String value, {
    bool isPassword = false,
    bool isDate = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller, // Use the passed controller
        obscureText:
            isPassword
                ? !isPasswordVisible
                : false, // Toggle visibility for password
        readOnly: isDate,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          hintText: value,
          hintStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey.shade900,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xff6351ec), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color(0xff6351ec), width: 2),
          ),
          prefixIcon: Icon(icon, color: Color(0xff6351ec)),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                  : isDate
                  ? GestureDetector(
                    onTap: () {
                      _pickDate();
                    },
                    child: Icon(Icons.calendar_today, color: Colors.grey),
                  )
                  : null,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showDeleteWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account Deletion Warning"),
          content: Text(
            "Are you sure you want to delete this account? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                AuthService().deleteCustomer(context: context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
                AuthService().signout(context: context);
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

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }

    // Calculate the age based on the selected date
    if (pickedDate != null) {
      int age = DateTime.now().year - pickedDate.year;
      if (DateTime.now().month < pickedDate.month ||
          (DateTime.now().month == pickedDate.month &&
              DateTime.now().day < pickedDate.day)) {
        age--;
      }

      // Update the age controller with the calculated age
      ageController.text = age.toString();
    }
  }
}
