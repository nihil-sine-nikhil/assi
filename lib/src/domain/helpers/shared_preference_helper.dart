import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_preference_constants.dart';

class SharedPreferencesHelper {
  static SharedPreferences? prefs;

  static initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// ------------------------------------------------------------
  /// Method that returns the user login or not , null if not set
  /// ------------------------------------------------------------
  static bool isLogin() {
    bool? isLogin;
    isLogin = prefs?.getBool(SharedPreferenceConstants.isLoggedIn) ?? false;
    return isLogin;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user login
  /// ----------------------------------------------------------
  static Future<bool?> setIsLogin(bool isLogin) async {
    return await prefs?.setBool(SharedPreferenceConstants.isLoggedIn, isLogin);
  }

  static Future<bool?> setName(String name) async {
    return await prefs?.setString(SharedPreferenceConstants.name, name);
  }

  static String getName() {
    return prefs?.getString(SharedPreferenceConstants.name) ?? "";
  }

  static clearSharedPreferences() async {
    prefs?.clear();
  }

  static logout() async {
    await FirebaseAuth.instance.signOut();
    clearSharedPreferences();
  }
}
