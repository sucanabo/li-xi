enum ImageType { file, network, assets }

class AppConst {
  AppConst._();

  static int dfBgColor = 0xffffc2b3;
  static String dfLixiImgFrontPath = 'assets/lixi_front.jpeg';
  static String dfLixiImgBackPath = 'assets/lixi_back_2.jpeg';
  static bool dfLixiFrontNetwork = false;
  static bool dfLixiBackNetwork = false;
  static List<int> dfLixiData = [500, 200, 100, 50, 20, 10, 5, 2, 1];
  static Duration dfAnimationDuration = Duration(milliseconds: 700);
}
