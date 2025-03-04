import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/services/database.dart';

class AdminViewProfile extends StatefulWidget {
  String? role;
  String? id;
  AdminViewProfile({required this.role, required this.id});

  @override
  _AdminViewProfileState createState() => _AdminViewProfileState();
}

class _AdminViewProfileState extends State<AdminViewProfile> {
  Stream? userStream;

  ontheload() async {
    userStream = await DatabaseMethods().getUserByIdAndRole(
      widget.id!,
      widget.role!,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        var user = snapshot.data.docs[0];
        if (widget.role == 'customer') {
          return Scaffold(
            backgroundColor: const Color(0xffd5dbff),
            appBar: AppBar(
              title: Text(
                'Customer Profile',
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
                    _buildTextField(Icons.person, "Full Name", user["name"]),
                    _buildTextField(Icons.email, "E-Mail", user["email"]),
                    _buildTextField(Icons.phone, "Phone No", user["phone"]),
                    _buildTextField(
                      Icons.assignment_ind_outlined,
                      "Age",
                      user["age"],
                      isDate: true,
                    ),
                    _buildTextField(
                      Icons.lock,
                      "Password",
                      user["password"],
                      isPassword: true,
                    ),

                    SizedBox(height: 35),
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
                            Text(
                              widget.id ?? '',
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
                                side: BorderSide(
                                  width: 2,
                                  color: Color(0xffF44336),
                                ),
                              ),
                            ),
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 16),
                            ),
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
        } else if (widget.role == 'organizer') {
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
                    padding: EdgeInsets.only(top: 45, bottom: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () {
                            Navigator.pop(context); // Navigate back
                          },
                        ),
                        Spacer(), // Adds flexible space between the icon and the text
                        Text(
                          "Organizer Profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(
                          flex: 2,
                        ), // Adds flexible space after the text to push it to the center
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
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(
                                'images/profile.jpg',
                              ), // Static image
                              backgroundColor: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 40),
                          _buildTextField(
                            // label: "Email Address",
                            // icon: Icons.email,
                            Icons.email,
                            "Email Address",
                            user["orgemail"],
                          ),
                          _buildTextField(
                            Icons.phone,
                            "Phone Number",
                            user["orgphone"],
                          ),
                          _buildTextField(
                            Icons.lock_open_outlined,
                            "Password",
                            user["orgpassword"],
                            isPassword: true,
                          ),
                          _buildTextField(
                            Icons.business,
                            "Organization Name",
                            user["orgname"],
                          ),
                          _buildTextField(
                            Icons.location_on,
                            "Organization Address",
                            user["orgaddress"],
                          ),
                          _buildTextField(
                            Icons.language,
                            "Website URL",
                            user["orgwebsite"],
                          ),
                          _buildTextField(
                            Icons.facebook_rounded,
                            "Facebook URL",
                            user["orgfacebook"],
                          ),
                          SizedBox(height: 25),
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
                                  Text(
                                    widget.id ?? '',
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
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(0xffF44336),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Container(child: Center(child: Text('Invalid Role'))),
          );
        }
      },
    );
  }

  Widget _buildTextField(
    IconData icon,
    String label,
    String initialValue, {
    bool isPassword = false,
    bool isDate = false,
  }) {
    // Create a TextEditingController and initialize it with the initialValue
    TextEditingController _controller = TextEditingController(
      text: initialValue,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: _controller, // Set the controller to the TextField
        obscureText: isPassword,
        readOnly: isDate, // Make it read-only if isDate is true
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
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
                  ? Icon(Icons.calendar_today, color: Colors.grey)
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
}
