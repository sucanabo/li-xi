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
  late ImageType lixiFrontType;
  late ImageType lixiBackType;
  Map<int, ImageType> _imgMapper = {
    0: ImageType.assets,
    1: ImageType.file,
    2: ImageType.network,
  };

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
    lixiFrontType = pref.getInt(PrefKey.lixiFrontType) != null
        ? _imgMapper[pref.getInt(PrefKey.lixiFrontType)]!
        : AppConst.dfLixiType;
    lixiBackType = pref.getInt(PrefKey.lixiBackType) != null
        ? _imgMapper[pref.getInt(PrefKey.lixiBackType)]!
        : AppConst.dfLixiType;
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

  void setLixiTheme(
      {ImageType? frontType, ImageType? backType, String? frontPath, String? backPath}) async {
    final pref = await SharedPreferences.getInstance();
    lixiFrontType = frontType ?? lixiFrontType;
    lixiBackType = backType ?? lixiBackType;
    lixiImgFrontPath = frontPath ?? lixiImgFrontPath;
    lixiImgBackPath = backPath ?? lixiImgBackPath;
    _imgMapper.forEach((key, value) {
      if (value == lixiFrontType) {
        pref.setInt(PrefKey.lixiFrontType, key);
        pref.setString(PrefKey.lixiFrontPath, lixiImgFrontPath);
      }
      if (value == lixiBackType) {
        pref.setInt(PrefKey.lixiBackType, key);
        pref.setString(PrefKey.lixiBackPath, lixiImgBackPath);
      }
    });
    notifyListeners();
  }

  setLixiThemeDefault({required bool isFront}) {
    setLixiTheme(
      frontType: isFront ? AppConst.dfLixiType : null,
      backType: !isFront ? AppConst.dfLixiType : null,
      frontPath: isFront ? AppConst.dfLixiImgFrontPath : null,
      backPath: !isFront ? AppConst.dfLixiImgBackPath : null,
    );
  }
}
