import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/services/auth.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);

  String? id, name, email, password, phone, age;

  // Declare controllers at the class level
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    password = await SharedPreferenceHelper().getUserPassword();
    phone = await SharedPreferenceHelper().getUserPhone();
    age = await SharedPreferenceHelper().getUserAge();

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
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("images/profile.jpg"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xff6351ec),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 18,
                      ),
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
                  onPressed: () async {
                    // Update data in shared pref and database
                    SharedPreferenceHelper().saveUserEmail(
                      emailController.text,
                    );
                    SharedPreferenceHelper().saveUserName(nameController.text);
                    SharedPreferenceHelper().saveUserPassword(
                      passwordController.text,
                    );
                    SharedPreferenceHelper().saveUserPhone(
                      phoneController.text,
                    );
                    SharedPreferenceHelper().saveUserAge(ageController.text);
                    Map<String, dynamic> userInfoMap = {
                      "name": nameController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                      "phone": phoneController.text,
                      "age": ageController.text,
                      "userid": id,
                    };

                    await DatabaseMethods()
                        .addUserDetail(userInfoMap, id!)
                        .then(
                          (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "User updated successfully!",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            );
                            setState(() {});
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
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Joined 31 October 2022",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(id ?? '', style: TextStyle(color: Colors.black54)),
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
        obscureText: isPassword,
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
                  ? Icon(Icons.visibility_off, color: Colors.grey)
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
                Navigator.of(context).pop(); // Close the dialog
                // Add delete logic here
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
