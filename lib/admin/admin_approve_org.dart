import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stage/admin/admin_view_profile.dart';

class AdminApproveOrg extends StatefulWidget {
  @override
  _AdminApproveOrgState createState() => _AdminApproveOrgState();
}

class _AdminApproveOrgState extends State<AdminApproveOrg> {
  Stream<QuerySnapshot>? usersStream;
  String searchQuery = ''; // Declare search query
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside the text field
        focusNode.unfocus();
      },
      child: Scaffold(
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
                  focusNode: focusNode,
                  onChanged: (query) {
                    setState(() {
                      searchQuery =
                          query; // Update the search query when the user types
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for users...',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
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
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
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
              // Display filtered users list
              Expanded(child: allUsers()),
            ],
          ),
        ),
      ),
    );
  }

  // Display the list of users
  Widget allUsers() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'organizer')
              .where('orgApproved', isEqualTo: false)
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the documents and filter them locally based on the search query
        var filteredData =
            snapshot.data!.docs.where((doc) {
              var orgName = doc['orgname'] as String; // Ensure it's a string
              var orgId = doc['orgid'] as String; // Ensure it's a string

              // Search query can match either orgName or orgId
              return orgName.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  orgId.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            var ds = filteredData[index].data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AdminViewProfile(
                        role: "organizer",
                        id: ds['orgid'],
                      );
                    },
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        ds['orgimage'] != null
                            ? NetworkImage(ds['orgimage'])
                            : AssetImage('images/profile.png'),
                  ),
                  title: Text(
                    ds['orgname'] ?? 'Unknown Name',
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
                        ds['orgid'].substring(0, 13) ?? 'Unknown ID',
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
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade800,
                          size: 30,
                        ),
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(filteredData[index].id)
                              .update({'orgApproved': true});
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red.shade800,
                          size: 30,
                        ),
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
