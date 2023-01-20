enum ShuffleMode { single, auto }

class AppConfig {
  ShuffleMode shuffleMode = ShuffleMode.auto;
  int shuffleNumber = 5;
  Duration animationDuration = const Duration(milliseconds: 700);
}
