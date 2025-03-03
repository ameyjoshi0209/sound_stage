import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/admin/admin_view_profile.dart';
import 'package:sound_stage/services/database.dart';

class AdminManageProfiles extends StatefulWidget {
  @override
  _AdminManageProfilesState createState() => _AdminManageProfilesState();
}

class _AdminManageProfilesState extends State<AdminManageProfiles> {
  Stream? usersStream;
  String searchQuery = ''; // Declare search query
  String selectedFilter = 'All'; // Declare filter selection
  TextEditingController searchController = TextEditingController();

  // Function to load users data
  ontheload() async {
    usersStream = await DatabaseMethods().getAllUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  void dispose() {
    // Dispose the controller when no longer needed to prevent memory leaks
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2575FC), Color(0xFFFFFFFF), // Black color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Search bar at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {
                    searchQuery =
                        query; // Update the search query when the user types
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for users...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchQuery = '';
                        searchController
                            .clear(); // Clear the text field when tapping the back icon
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        // You can use ScaleTransition, FadeTransition, etc.
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child:
                          searchQuery.isEmpty
                              ? GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_rounded, // Back icon
                                  key: ValueKey('back'),
                                ),
                              )
                              : Icon(
                                Icons.close, // Close icon when typing
                                key: ValueKey('close'),
                              ),
                    ),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ), // Search icon
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            // Row of buttons for filter selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          selectedFilter =
                              'All'; // Set the selected filter to "All"
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedFilter == 'All'
                                ? Color(0xFF2C2C2C)
                                : Color(0x7FFFFFFF),
                      ),
                      child: Text(
                        'All',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          selectedFilter =
                              'customer'; // Set the selected filter to "User"
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedFilter == 'customer'
                                ? Color(0xFF2C2C2C)
                                : Color(0x7FFFFFFF),
                      ),
                      child: Text(
                        'Customer',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          selectedFilter =
                              'organizer'; // Set the selected filter to "organizer"
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedFilter == 'organizer'
                                ? Color(0xFF2C2C2C)
                                : Color(0x7FFFFFFF),
                      ),
                      child: Text(
                        'Organizer',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display filtered users list
            Expanded(child: allUsers()),
          ],
        ),
      ),
    );
  }

  // Filter users based on search query and selected filter
  List<DocumentSnapshot> filterUsers(List<DocumentSnapshot> docs) {
    return docs.where((doc) {
      // Skip documents that don't have the 'role' field or the data is null
      var docData = doc.data();
      if (docData == null ||
          !(docData as Map<String, dynamic>).containsKey('role')) {
        return false; // Skip this document if no 'role' field or no data
      }
      bool matchesSearchQuery = false;

      // Use the correct field based on the role
      if (doc['role'] == 'organizer' && doc['orgname'] != null) {
        matchesSearchQuery = doc['orgname'].toString().toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      } else if (doc['role'] == 'customer' && doc['name'] != null) {
        matchesSearchQuery = doc['name'].toString().toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      }

      bool matchesFilter =
          selectedFilter == 'All' || doc['role'] == selectedFilter;

      // Check if the selected filter is "User" or "organizer" and filter accordingly
      if (selectedFilter == 'customer') {
        return matchesSearchQuery && matchesFilter && doc['role'] == 'customer';
      } else if (selectedFilter == 'organizer') {
        return matchesSearchQuery &&
            matchesFilter &&
            doc['role'] == 'organizer';
      } else {
        return matchesSearchQuery; // For "All", no role-based filtering is needed
      }
    }).toList();
  }

  // Display the list of users
  Widget allUsers() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Filter the users based on the search query and selected filter
        List<DocumentSnapshot> filteredUsers = filterUsers(snapshot.data.docs);

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            var ds = filteredUsers[index];

            // Safely access the correct field based on the role
            String displayName = '';
            String displayId = '';
            if (ds['role'] == 'organizer') {
              displayName =
                  ds['orgname'] ?? 'Unknown'; // Use orgname for organizer
              displayId = ds['orgid'] ?? 'Unknown'; // Use orgid for organizer
            } else if (ds['role'] == 'customer') {
              displayName = ds['name'] ?? 'Unknown'; // Use name for customer
              displayId = ds['userid'] ?? 'Unknown'; // Use userid for customer
            }
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminViewProfile(role: ds['role'], id: displayId);
                    },
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://www.example.com/image1.jpg', // Placeholder image
                    ),
                  ),
                  title: Text(
                    displayName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ds['role'] ?? 'Unknown Role',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        displayId.substring(0, 16),
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Delete user logic here
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
