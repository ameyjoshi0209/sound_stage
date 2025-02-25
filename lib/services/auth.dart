import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sound_stage/pages/bottomnav.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class AuthService {
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

        await Future.delayed(const Duration(seconds: 1));
        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserPassword(password);
        await SharedPreferenceHelper().saveUserId(
          FirebaseAuth.instance.currentUser!.uid,
        );
        await SharedPreferenceHelper().saveUserName(username);
        await SharedPreferenceHelper().saveUserPhone(userDoc['phone']);
        await SharedPreferenceHelper().saveUserAge(userDoc['age']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const BottomNav(),
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
}
