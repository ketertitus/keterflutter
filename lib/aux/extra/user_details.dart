import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sharedpref.dart';

class CurrentUser extends ChangeNotifier {
  // ignore: unused_field
  late String _userName;
  late String _bizzName;
  late ProjectPreferences _preferences;

  Future<String> getUserName() async {
    _userName = "null";
    _preferences = ProjectPreferences();
    String? temp = FirebaseAuth.instance.currentUser == null
        ? "Alphajiri"
        : await _preferences.getName(FirebaseAuth.instance.currentUser!.email);
    _userName = temp ?? "got null";

    return _userName;
  }

  Future<String> getBizzName() async {
    _bizzName = "ungotten";
    _preferences = ProjectPreferences();
    _bizzName = await _preferences
        .getbizzName(FirebaseAuth.instance.currentUser!.email!);
    return _bizzName;
  }
}
