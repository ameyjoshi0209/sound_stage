import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addOrganizerDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addEvent(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getallEvents() async {
    return await FirebaseFirestore.instance.collection("Event").snapshots();
  }

  Future<Stream<QuerySnapshot>> getEventByOrganizerId(String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .where('OrganizerId', isEqualTo: id)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getEventById(String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .where('EventId', isEqualTo: id)
        .snapshots();
  }

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

  Future updateBookingStatus(
    String customerId,
    String eventId,
    String bookingId,
  ) async {
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

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getBookingsByUserId(
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("booking")
        .doc(id)
        .snapshots();
  }
}
