// This file contains the code to interact with the Firestore database.
// It contains functions to add, update, and fetch data from the Firestore database.

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // ADDING USER DATA TO FIRESTORE DATABASE USING USERID
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }

  // ADDING ORGANIZER DATA TO FIRESTORE DATABASE USING ORGANIZERID
  Future addOrganizerDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // ADDING EVENT DATA TO FIRESTORE DATABASE USING EVENTID
  Future addEvent(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .doc(id)
        .set(userInfoMap);
  }

  Future deleteEvent(String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .doc(id)
        .delete();
  }

  // FETCHING ALL EVENTS DATA FROM FIRESTORE DATABASE USING USERID
  Future<Stream<QuerySnapshot>> getallEvents() async {
    return await FirebaseFirestore.instance.collection("Event").snapshots();
  }

  // FETCHING ALL EVENTS DATA FROM FIRESTORE DATABASE USING ORGANIZERID
  Future<Stream<QuerySnapshot>> getEventByOrganizerId(String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .where('OrganizerId', isEqualTo: id)
        .snapshots();
  }

  // FETCHING ALL EVENTS DATA FROM FIRESTORE DATABASE USING EVENTID
  Future<Stream<QuerySnapshot>> getEventById(String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .where('EventId', isEqualTo: id)
        .snapshots();
  }

  // UPDATING EVENT DATA IN FIRESTORE DATABASE USING EVENTID
  // Here we are updating the EventApproved field to true, which means the event is approved by the admin.
  Future approveEvent(String id) async {
    return await FirebaseFirestore.instance.collection("Event").doc(id).update({
      "EventApproved": true,
    });
  }

  Future addAdminTickets(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Tickets")
        .add(userInfoMap);
  }

  Future updateTicketStatus(String customerId) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection("Tickets")
            .where("CustomerId", isEqualTo: customerId)
            .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({"Attended": true});
    }
  }

  // FETCHING ALL EVENTS DATA FROM FIRESTORE DATABASE USING CATEGORY FIELD
  Future<Stream<QuerySnapshot>> getEventCategories(String category) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .where("Category", isEqualTo: category)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getTicketsByEventId(String eventId) async {
    return await FirebaseFirestore.instance
        .collection("Tickets")
        .where("EventId", isEqualTo: eventId)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getTicketsByCustomerId(
    String customerId,
  ) async {
    return FirebaseFirestore.instance
        .collection("Tickets")
        .where("CustomerId", isEqualTo: customerId)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserByIdAndRole(
    String id,
    String role,
  ) async {
    if (role == "customer") {
      return await FirebaseFirestore.instance
          .collection("users")
          .where('userid', isEqualTo: id)
          .snapshots();
    } else if (role == "organizer") {
      return await FirebaseFirestore.instance
          .collection("users")
          .where('orgid', isEqualTo: id)
          .snapshots();
    } else {
      throw Exception("Invalid role: $role");
    }
  }
}
