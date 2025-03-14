// This file is a shared preference helper class that contains functions to save, get, and remove
// user, organizer, and admin data from shared preferences.

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // KEYS FOR USER DATA
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPhoneKey = "USERPHONEKEY";
  static String userAgeKey = "USERAGEKEY";
  static String userPasswordKey = "USERPASSWORDKEY";
  static String userImageKey = "USERIMAGEKEY";

  // KEYS FOR ORGANIZER DATA
  static String organizerIdKey = "ORGANIZERKEY";
  static String organizerEmailKey = "ORGANIZEREMAILKEY";
  static String organizerPasswordKey = "ORGANIZERPASSWORDKEY";
  static String organizerNameKey = "ORGANIZERNAMEKEY";

  // KEYS FOR ADMIN DATA
  static String adminEmailKey = "ADMINEMAILKEY";
  static String adminPasswordKey = "ADMINPASSWORDKEY";

  // SAVE SHAREDPREFERENCES FOR USER DATA
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserPassword(String getUserPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPasswordKey, getUserPassword);
  }

  Future<bool> saveUserPhone(String getUserPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhoneKey, getUserPhone);
  }

  Future<bool> saveUserAge(String getUserAge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAgeKey, getUserAge);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  // GET SHAREDPREFERENCES FOR USER DATA
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPasswordKey);
  }

  Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPhoneKey);
  }

  Future<String?> getUserAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAgeKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  // REMOVE SHAREDPREFERENCES FOR USER DATA
  Future<String?> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userIdKey);
  }

  Future<String?> removeUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userNameKey);
  }

  Future<String?> removeUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userPasswordKey);
  }

  Future<String?> removeUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userEmailKey);
  }

  Future<String?> removeUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userPhoneKey);
  }

  Future<String?> removeUserAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userAgeKey);
  }

  Future<String?> removeUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userImageKey);
  }

  // SAVE SHAREDPREFERENCES FOR ORGANIZER DATA
  Future<bool> saveOrganizerId(String getOrganizerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(organizerIdKey, getOrganizerId);
  }

  Future<bool> saveOrganizerName(String getOrganizerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(organizerNameKey, getOrganizerName);
  }

  Future<bool> saveOrganizerEmail(String getOrganizerEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(organizerEmailKey, getOrganizerEmail);
  }

  Future<bool> saveOrganizerPassword(String getOrganizerPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(organizerPasswordKey, getOrganizerPassword);
  }

  // GET SHAREDPREFERENCES FOR ORGANIZER DATA
  Future<String?> getOrganizerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(organizerIdKey);
  }

  Future<String?> getOrganizerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(organizerNameKey);
  }

  Future<String?> getOrganizerEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(organizerEmailKey);
  }

  Future<String?> getOrganizerPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(organizerPasswordKey);
  }

  // REMOVE SHAREDPREFERENCES FOR ORGANIZER DATA
  Future<String?> removeOrganizerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(organizerIdKey);
  }

  Future<String?> removeOrganizerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userNameKey);
  }

  Future<String?> removeOrganizerEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(organizerEmailKey);
  }

  Future<String?> removeOrganizerPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(organizerPasswordKey);
  }

  // SAVE SHAREDPREFERENCES FOR ADMIN DATA
  Future<bool> saveAdminEmail(String getAdminEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminEmailKey, getAdminEmail);
  }

  Future<bool> saveAdminPassword(String getAdminPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(adminPasswordKey, getAdminPassword);
  }

  // GET SHAREDPREFERENCES FOR ADMIN DATA
  Future<String?> getAdminEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminEmailKey);
  }

  Future<String?> getAdminPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminPasswordKey);
  }

  // REMOVE SHAREDPREFERENCES FOR ADMIN DATA
  Future<String?> removeAdminEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(adminEmailKey);
  }

  Future<String?> removeAdminPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(adminPasswordKey);
  }
}
