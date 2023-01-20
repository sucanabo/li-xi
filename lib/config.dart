enum ShuffleMode { single, auto }

class AppConfig {
  ShuffleMode _shuffleMode = ShuffleMode.auto;
  int _shuffleAutoCount = 5;

  get getShuffleMode => _shuffleMode;
  get getShuffleNumber => _shuffleMode == ShuffleMode.auto ? _shuffleAutoCount : 1;

  set shuffleMode(ShuffleMode value) {
    _shuffleMode = value;
  }

  set shuffleNumber(int value) {
    _shuffleAutoCount = value;
  }

  Duration animationDuration = const Duration(milliseconds: 700);
}
