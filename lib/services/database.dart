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

  Future addUserBooking(
    Map<String, dynamic> userInfoMap,
    String id,
    String bookId,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("booking")
        .doc(bookId)
        .set(userInfoMap);
  }

  Future addAdminTickets(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Tickets")
        .add(userInfoMap);
  }

  Future updateBookingStatus(String customerId, String bookingId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(customerId)
        .collection("booking")
        .doc(bookingId)
        .update({"Attended": false});
  }

  Future<Stream<QuerySnapshot>> getbookings(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("booking")
        .snapshots();
  }

  // FETCHING ALL EVENTS DATA FROM FIRESTORE DATABASE USING CATEGORY FIELD
  Future<Stream<QuerySnapshot>> getEventCategories(String category) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .where("Category", isEqualTo: category)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getTickets() async {
    return await FirebaseFirestore.instance.collection("Tickets").snapshots();
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

  Future<Stream<QuerySnapshot>> getBookingByUserId(
    String customerId,
    String bookingId,
  ) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(customerId)
        .collection("booking")
        .where("BookingId", isEqualTo: bookingId)
        .snapshots();
  }
}
