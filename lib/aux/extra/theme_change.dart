import 'package:flutter/material.dart';
import 'sharedpref.dart';

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late ProjectPreferences _preferences;
  bool get isDark => _isDark;

  ModelTheme() {
    _isDark = false;
    _preferences = ProjectPreferences();
    getPreferences();
  }
//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
