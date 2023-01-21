import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lixi/const/pref_key.dart';
import 'package:lixi/const/value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool isLoading = true;
  late Color bgColor;
  List<int> lixiData = [];
  late String lixiImgFrontPath;
  late String lixiImgBackPath;
  late bool isLixiFontNetwork;
  late bool isLixiBackNetwork;

  void initState() async {
    final pref = await SharedPreferences.getInstance();
    //load lixi data
    final data = pref.getString(PrefKey.lixiData);
    if (data != null) {
      lixiData = (jsonDecode(data) as List).map((it) => int.parse(it.toString())).toList();
    } else {
      lixiData = AppConst.dfLixiData;
    }
    //load theme color
    bgColor = Color(pref.getInt(PrefKey.bgColor) ?? AppConst.dfBgColor);
    isLixiFontNetwork = pref.getBool(PrefKey.lixiFrontNetwork) ?? AppConst.dfLixiFrontNetwork;
    isLixiBackNetwork = pref.getBool(PrefKey.lixiBackNetwork) ?? AppConst.dfLixiBackNetwork;
    lixiImgFrontPath = pref.getString(PrefKey.lixiFrontPath) ?? AppConst.dfLixiImgFrontPath;
    lixiImgBackPath = pref.getString(PrefKey.lixiBackPath) ?? AppConst.dfLixiImgBackPath;
    isLoading = false;
    notifyListeners();
  }

  void changeColorTheme(Color color) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt(PrefKey.bgColor, color.value);
    bgColor = color;
    notifyListeners();
  }

  void setLixiData(List<int> data) async {
    lixiData = data;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.setString(PrefKey.lixiData, jsonEncode(lixiData));
  }
}
