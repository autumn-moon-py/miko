import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/user_model.dart';

class ImageViewModel with ChangeNotifier {
  Map get imageMap => _imageMap;
  final user = User();

  Future<void> init() async {
    _imageMap = await user.loadImage(_imageMap);
  }

  void lockImage(String image) {
    _imageMap[image] = true;
    notifyListeners();
    user.saveImage(_imageMap);
    EasyLoading.showToast('已解锁图鉴：$image',
        toastPosition: EasyLoadingToastPosition.bottom);
  }

  void lockAllImage() {
    for (var i = 0; i < imageList1.length; i++) {
      _imageMap[imageList1[i]] = true;
    }
    notifyListeners();
  }

  void errorLock() {
    List<String> waitLock = [];
    _imageMap.forEach((key, value) {
      if (value == true && key.length == 5) {
        waitLock.add(key);
      }
      if (key.length > 5) {
        String wait = key;
        if (_imageMap[wait]) {
          waitLock.remove(wait.replaceAll('-n', ''));
        }
      }
    });
    if (waitLock.isEmpty) return;
    for (var i = 0; i < waitLock.length; i++) {
      for (var j = 0; j < imageList2.length; j++) {
        final waitImage = waitLock[i];
        final image = imageList2[j];
        if (waitImage.length != image.length && image.startsWith(waitImage)) {
          lockImage(imageList2[j]);
          break;
        }
      }
    }
  }

  ///旧图鉴
  List<String> imageList1 = [
    'S1-01',
    'S1-02',
    'S1-03',
    'S1-04',
    'S1-05',
    'E1-01',
    'E1-02',
    'S2-01',
    'S2-02',
    'S2-03',
    'S2-04',
    'S2-05',
    'S2-06',
    'S2-07',
    'S2-08',
    'E2-01',
    'E2-02',
    'E2-03',
    'E2-04',
    'S3-01',
    'S3-02',
    'S3-03',
    'S3-04',
    'E3-01',
    'E3-02',
    'E3-03',
    'S4-01',
    'S4-02',
    'S4-03',
    'S4-04',
    'S4-05',
    'S4-06',
    'S5-01',
    'S5-02',
    'S5-03',
    'S5-04',
    'S5-05',
    'S5-06',
    'S6-01',
    'S6-02',
    'S6-03',
    'S6-04',
    'S6-05',
    'S6-06',
    'S6-07',
    'W1-01',
    'W1-02',
    'W1-03',
    'W1-04',
    'W1-05',
    'W1-06',
    'W1-07',
    'W1-08',
    'W1-09'
  ];

  ///新图鉴
  List<String> imageList2 = [
    'S1-01-n',
    'S1-02',
    'S1-03',
    'S1-04',
    'S1-05-n',
    'E1-01-n',
    'E1-02-n',
    'S2-01-n',
    'S2-02',
    'S2-03',
    'S2-04',
    'S2-05',
    'S2-06',
    'S2-07',
    'S2-08',
    'E2-01',
    'E2-02',
    'E2-03',
    'E2-04',
    'S3-01-n',
    'S3-02',
    'S3-03-n',
    'S3-04-n',
    'E3-01',
    'E3-02',
    'E3-03',
    'S4-01-n',
    'S4-02',
    'S4-03-n',
    'S4-04',
    'S4-05-n',
    'S4-06-n',
    'S5-01-n',
    'S5-02-n',
    'S5-03-n',
    'S5-04-n',
    'S5-05',
    'S5-06',
    'S6-01-n',
    'S6-02-n',
    'S6-03-n',
    'S6-04-n',
    'S6-05',
    'S6-06',
    'S6-07',
    'W1-01',
    'W1-02',
    'W1-03',
    'W1-04',
    'W1-05',
    'W1-06',
    'W1-07',
    'W1-08',
    'W1-09'
  ];

  ///图鉴解锁
  Map _imageMap = {
    '0': false,
    'E1-01-n': false,
    'E1-01': false,
    'E1-02': false,
    'E1-02-n': false,
    'E1-03': false,
    'E2-01': false,
    'E2-02': false,
    'E2-03': false,
    'E2-04': false,
    'E3-01': false,
    'E3-02': false,
    'E3-03': false,
    'S1-01-n': false,
    'S1-01': false,
    'S1-02': false,
    'S1-03': false,
    'S1-04': false,
    'S1-05-n': false,
    'S1-05': false,
    'S2-01-n': false,
    'S2-01': false,
    'S2-02': false,
    'S2-03': false,
    'S2-04': false,
    'S2-05': false,
    'S2-06': false,
    'S2-07': false,
    'S2-08': false,
    'S3-01-n': false,
    'S3-01': false,
    'S3-02': false,
    'S3-03-n': false,
    'S3-03': false,
    'S3-04-n': false,
    'S3-04': false,
    'S4-01-n': false,
    'S4-01': false,
    'S4-02': false,
    'S4-03-n': false,
    'S4-03': false,
    'S4-04': false,
    'S4-05-n': false,
    'S4-05': false,
    'S4-06-n': false,
    'S4-06': false,
    'S5-01-n': false,
    'S5-01': false,
    'S5-02-n': false,
    'S5-02': false,
    'S5-03-n': false,
    'S5-03': false,
    'S5-04-n': false,
    'S5-04': false,
    'S5-05': false,
    'S5-06': false,
    'S6-01': false,
    'S6-01-n': false,
    'S6-02': false,
    'S6-02-n': false,
    'S6-03': false,
    'S6-03-n': false,
    'S6-04': false,
    'S6-04-n': false,
    'S6-05': false,
    'S6-06': false,
    'S6-07': false,
    'W1-01': false,
    'W1-02': false,
    'W1-03': false,
    'W1-04': false,
    'W1-05': false,
    'W1-06': false,
    'W1-07': false,
    'W1-08': false,
    'W1-09': false
  };
}
