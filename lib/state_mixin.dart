import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lixi/config.dart';
import 'package:lixi/model/background_model.dart';

mixin AppStateMixin<T extends StatefulWidget> on State<T> {
  final AppConfig config = AppConfig();

  appShuffle(Function() func) {
    int count = config.getShuffleNumber;
    Timer.periodic(config.animationDuration, (timer) {
      func.call();
      count--;
      if (count <= 0) timer.cancel();
    });
  }

  PosBackground getPosBackground(
    double width,
    List<int> data, {
    int columnCount = 3,
    double itemHeight = 250,
  }) {
    final itemCount = data.length;
    final double itemWidth = width / columnCount;
    final double height = (itemCount ~/ columnCount + itemCount % columnCount) * itemHeight;
    int rowCount = 0;
    final List<PosItem> pos = List.generate(itemCount, (index) {
      if (index != 0 && index % columnCount == 0) {
        rowCount++;
      }
      return PosItem(
        id: index,
        x: (index % columnCount) * itemWidth,
        y: rowCount * itemHeight,
        data: data[index],
      );
    });
    return PosBackground(
        pos: pos, height: height, width: width, itemWidth: itemWidth, itemHeight: itemHeight);
  }
}
