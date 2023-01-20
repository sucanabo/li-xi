import 'package:flutter/cupertino.dart';
import 'package:lixi/config.dart';

mixin AppStateMixin<T extends StatefulWidget> on State<T> {
  final AppConfig config = AppConfig();

  Function()? shuffle({Function()? shuffleFunc}) {
    print('getSuffle');
    late int num;
    switch (config.shuffleMode) {
      case ShuffleMode.single:
        num = 1;
        break;
      case ShuffleMode.auto:
        num = config.shuffleNumber;
        break;
      default:
        num = 0;
    }

    return () async {
      while (num > 0) {
        print('num $num');
        shuffleFunc?.call();
        await Future.delayed(config.animationDuration).then((value) {
          setState(() {});
          num--;
        });
      }
    };
  }
}
