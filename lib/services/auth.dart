import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sound_stage/admin/admin_dashboard.dart';
import 'package:sound_stage/admin/admin_signin.dart';
import 'package:sound_stage/organizer/org_dash.dart';
import 'package:sound_stage/organizer/org_signin.dart';
import 'package:sound_stage/pages/bottomnav.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class AuthService {
  // User Authentication Methods for Sign Up, Sign In, checkLoggedIn, and Sign Out
  Future<void> signup({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));
      await SharedPreferenceHelper().saveUserName(name);
      await SharedPreferenceHelper().saveUserEmail(email);
      await SharedPreferenceHelper().saveUserPassword(password);
      await SharedPreferenceHelper().saveUserId(
        FirebaseAuth.instance.currentUser!.uid,
      );
      String signupID = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> uploadUser = {
        "name": name,
        "email": email,
        "password": password,
        "role": "customer",
        "userid": signupID,
      };
      await DatabaseMethods().addUserDetail(uploadUser, signupID).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const BottomNav(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else {
        message = 'Something went wrong';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> signin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .get();
      if (userDoc.exists) {
        // Assuming the user document contains 'username' field
        String username = userDoc['name'];

        // Save user details
        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserPassword(password);
        await SharedPreferenceHelper().saveUserId(
          FirebaseAuth.instance.currentUser!.uid,
        );
        await SharedPreferenceHelper().saveUserName(username);
        // Navigate to BottomNav screen without delay
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const BottomNav(),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Something went wrong';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> signout({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));

      await SharedPreferenceHelper().removeUserId();
      await SharedPreferenceHelper().removeUserEmail();
      await SharedPreferenceHelper().removeUserPassword();
      await SharedPreferenceHelper().removeUserName();
      await SharedPreferenceHelper().removeUserPhone();

      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkUserLoggedIn({required BuildContext context}) async {
    String? savedEmail = await SharedPreferenceHelper().getUserEmail() ?? "";
    String? savedPassword =
        await SharedPreferenceHelper().getUserPassword() ?? "";

    if (savedEmail != "" &&
        savedPassword != "" &&
        FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  // Organizer Authentication Methods for Sign Up, Sign In, checkLoggedIn, and Sign Out
  Future<void> registerOrg({
    required BuildContext context,
    required String orgName,
    required String orgEmail,
    required String orgPassword,
    required String? orgPhone,
    required String? orgAddress,
    required String? orgWebsite,
    required String? orgFacebook,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: orgEmail,
        password: orgPassword,
      );
      await Future.delayed(const Duration(seconds: 1));
      String signupID = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> uploadOrganizer = {
        "orgname": orgName,
        "orgemail": orgEmail,
        "orgpassword": orgPassword,
        "orgphone": orgPhone,
        "orgaddress": orgAddress,
        "orgwebsite": orgWebsite,
        "orgfacebook": orgFacebook,
        "role": "organizer",
        "orgid": signupID,
      };
      await DatabaseMethods()
          .addOrganizerDetail(uploadOrganizer, signupID)
          .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: const Text('Organizer Profile Created Successfully'),
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      } else {
        message = 'Something went wrong';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> orgSignIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .get();
      if (userDoc.exists) {
        String name = userDoc['orgname'];

        await Future.delayed(const Duration(seconds: 1));
        await SharedPreferenceHelper().saveOrganizerEmail(email);
        await SharedPreferenceHelper().saveOrganizerPassword(password);
        await SharedPreferenceHelper().saveOrganizerId(
          FirebaseAuth.instance.currentUser!.uid,
        );
        await SharedPreferenceHelper().saveOrganizerName(name);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => OrganizerDashboard(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Something went wrong';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkOrgLoggedIn({required BuildContext context}) async {
    String? savedEmail =
        await SharedPreferenceHelper().getOrganizerEmail() ?? "";
    String? savedPassword =
        await SharedPreferenceHelper().getOrganizerPassword() ?? "";

    if (savedEmail != "" && savedPassword != "") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> orgSignOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));

      await SharedPreferenceHelper().removeOrganizerEmail();
      await SharedPreferenceHelper().removeOrganizerPassword();
      await SharedPreferenceHelper().removeOrganizerId();
      await SharedPreferenceHelper().removeOrganizerName();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => OrgSignIn()),
        (route) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  // Admin Authentication Methods for Sign In, checkLoggedIn, and Sign Out
  Future<void> adminSignIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("admin")
              .doc("admin")
              .get();
      if (userDoc.exists) {
        if (email != userDoc['adminEmail'] ||
            password != userDoc['adminPassword']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: const Text('Invalid Admin Credentials'),
            ),
          );
          return;
        }

        await Future.delayed(const Duration(seconds: 1));
        await SharedPreferenceHelper().saveAdminEmail(email);
        await SharedPreferenceHelper().saveAdminPassword(password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AdminDashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: const Text('Admin Account Not Found'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkAdminLoggedIn({required BuildContext context}) async {
    String? savedEmail = await SharedPreferenceHelper().getAdminEmail() ?? "";
    String? savedPassword =
        await SharedPreferenceHelper().getAdminPassword() ?? "";

    if (savedEmail != "" && savedPassword != "") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> adminSignOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));

      await SharedPreferenceHelper().removeAdminEmail();
      await SharedPreferenceHelper().removeAdminPassword();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => AdminSignIn()),
        (route) => false,
      );
    } catch (e) {
      print(e);
    }
  }
}
