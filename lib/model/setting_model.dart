import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  bool bgm = true;
  bool buttonMusic = true;
  bool newImage = false;
  bool waitTyping = true;
  bool waitOffline = true;
  bool bubbleAnimation = true;
  int nowMikoAvatar = 1;
  late SharedPreferences prefs;

  Future<void> save() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('bgm', bgm);
    prefs.setBool('buttonMusic', buttonMusic);
    prefs.setBool('newImage', newImage);
    prefs.setBool('waitTyping', waitTyping);
    prefs.setBool('waitOffline', waitOffline);
    prefs.setBool('bubbleAnimation', bubbleAnimation);
    prefs.setInt('nowMikoAvatar', nowMikoAvatar);
  }

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    bgm = prefs.getBool('bgm') ?? bgm;
    buttonMusic = prefs.getBool('buttonMusic') ?? buttonMusic;
    newImage = prefs.getBool('newImage') ?? newImage;
    waitTyping = prefs.getBool('waitTyping') ?? waitTyping;
    waitOffline = prefs.getBool('waitOffline') ?? waitOffline;
    bubbleAnimation = prefs.getBool('bubbleAnimation') ?? bubbleAnimation;
    nowMikoAvatar = prefs.getInt('nowMikoAvatar') ?? nowMikoAvatar;
  }
}
