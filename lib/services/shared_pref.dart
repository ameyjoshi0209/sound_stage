import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPhoneKey = "USERPHONEKEY";
  static String userAgeKey = "USERAGEKEY";
  static String userPasswordKey = "USERPASSWORDKEY";

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
}
