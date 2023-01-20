import 'package:flutter/material.dart';
import 'package:lixi/const/pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  late Color bgColor;

  void initState() async {
    final pref = await SharedPreferences.getInstance();
    bgColor = Color(pref.getInt(PrefKey.bgColor) ?? 0xffffc2b3);
  }

  void changeColorTheme(Color color) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt(PrefKey.bgColor, color.value);
    bgColor = color;
    notifyListeners();
  }
}
