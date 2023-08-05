import 'package:flutter/foundation.dart';
import 'package:miko/model/setting_model.dart';

class SettingViewModel with ChangeNotifier {
  final Setting _setting = Setting();

  Future<void> init() async {
    await _setting.load();
  }

  void changeNowMikoAvatar(int nowMikoAvatar) {
    _setting.nowMikoAvatar = nowMikoAvatar;
    notifyListeners();
    _setting.save();
  }

  int get nowMikoAvatar => _setting.nowMikoAvatar;

  void changeBgm(bool value) {
    _setting.bgm = value;
    notifyListeners();
    _setting.save();
  }

  void changeButtonMusic(bool value) {
    _setting.buttonMusic = value;
    notifyListeners();
    _setting.save();
  }

  void changeNewImage(bool value) {
    _setting.newImage = value;
    notifyListeners();
    _setting.save();
  }

  void changeWaitTyping(bool value) {
    _setting.waitTyping = value;
    notifyListeners();
    _setting.save();
  }

  void changeWaitOffline(bool value) {
    _setting.waitOffline = value;
    notifyListeners();
    _setting.save();
  }

  void changeBubbleAnimation(bool value) {
    _setting.bubbleAnimation = value;
    notifyListeners();
    _setting.save();
  }

  bool get bgm => _setting.bgm;
  bool get buttonMusic => _setting.buttonMusic;
  bool get newImage => _setting.newImage;
  bool get waitTyping => _setting.waitTyping;
  bool get waitOffline => _setting.waitOffline;
  bool get bubbleAnimation => _setting.bubbleAnimation;
}
