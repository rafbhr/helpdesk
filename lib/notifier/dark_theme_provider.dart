import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/sharedPreference/PreferenceKeys.dart';

class DarkThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    themePreferences.setDarkTheme(value);
    notifyListeners();
  }
}

class ThemePreferences {

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PREF_IS_DARK_THEME, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PREF_IS_DARK_THEME) ?? false;
  }
}