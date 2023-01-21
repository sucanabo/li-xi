import 'package:flutter/material.dart';
import 'package:lixi/const/pref_key.dart';
import 'package:lixi/const/value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool isLoading = true;
  late Color bgColor;

  void initState() async {
    final pref = await SharedPreferences.getInstance();
    bgColor = Color(pref.getInt(PrefKey.bgColor) ?? AppConst.defaultBgColor);
    isLoading = false;
    notifyListeners();
  }

  void changeColorTheme(Color color) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt(PrefKey.bgColor, color.value);
    bgColor = color;
    notifyListeners();
  }
}
