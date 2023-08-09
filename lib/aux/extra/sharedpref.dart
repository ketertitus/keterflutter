import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectPreferences {
  // ignore: constant_identifier_names
  static const THEME_KEY = "theme_key";
  static String mainUserMail = "userMail";
  static const userName = "Default";

  setMail(String mail) => mainUserMail = mail;
  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_KEY, value);
  }

  setUser(
      {required String userName,
      required String bizzName,
      required String userMail}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userMail, userName);
    sharedPreferences.setString(userName, bizzName);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_KEY) ?? true;
  }

  getName(String? mail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(mail ?? "null") ?? "null";
  }

  getbizzName(String mail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(await getName(mail)) ?? "null";
  }
}
