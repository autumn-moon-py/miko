import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miko/page/setting/setting_view_model.dart';
import 'package:miko/utils/routes.dart';
import 'package:provider/provider.dart';

import 'app_utils.dart';

class DialogUtils {
  static void init(BuildContext context) {
    showApril(context);
    showBirthday(context);
  }

  static Widget whiteBackground({required List<Widget> children}) {
    return SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min, children: children)))
        ]));
  }

  static void closeDialog({required Function onClose}) {
    onClose.call();
    Get.back();
  }

  static void dialogUtils(
      {required String titleText,
      required String subtitle,
      required String image,
      required String button,
      required Function onTapButton,
      required String cancelText}) {
    final title = Text(titleText,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
            fontSize: 20));
    final subTitle = Text(subtitle, style: const TextStyle(color: Colors.grey));
    final showImage = Builder(builder: (context) {
      return GestureDetector(
          onTap: () => MyRoute.to(context, '/image_view', image),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/photo/$image.webp',
                  width: 250, fit: BoxFit.cover)));
    });
    final downloadImage = Builder(builder: (context) {
      return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0,
                    1
                  ],
                  colors: [
                    Color.fromRGBO(78, 116, 223, 1),
                    Color.fromRGBO(48, 92, 206, 1)
                  ])),
          child: Text(button,
              style: const TextStyle(color: Colors.white, fontSize: 25)));
    });
    final cancel = Builder(builder: (context) {
      return Text(cancelText,
          style: const TextStyle(color: Colors.grey, fontSize: 20));
    });
    Get.dialog(whiteBackground(children: [
      title,
      const SizedBox(height: 5),
      subTitle,
      const SizedBox(height: 10),
      showImage,
      const SizedBox(height: 10),
      downloadImage,
      const SizedBox(height: 10),
      cancel
    ]));
  }

  ///生日弹窗
  static Future<void> showBirthday(BuildContext context) async {
    final now = DateTime.now();
    if (now.month != 4 || now.day != 5) {
      context.read<SettingViewModel>().changeBirthday(false);
    }
    final show = context.read<SettingViewModel>().birthday;
    if (now.month == 4 && now.day == 5 && !show) {
      context.read<SettingViewModel>().changeBirthday(true);
      const image = 'birthday';
      dialogUtils(
          titleText: '生日快乐!',
          subtitle: 'Miko已经${now.year - 1999}岁啦!',
          image: image,
          button: '下载贺图',
          onTapButton: () {
            closeDialog(onClose: () => Utils.downloadImage(image));
          },
          cancelText: '以后再说');
    }
  }

  ///愚人节弹窗
  static Future<void> showApril(BuildContext context) async {
    DateTime now = DateTime.now();
    if (now.month != 04 && now.day != 01) {
      context.read<SettingViewModel>().changeApril(false);
    }
    final show = context.read<SettingViewModel>().april;
    if (now.month == 04 && now.day == 01 && !show) {
      context.read<SettingViewModel>().changeApril(true);
      const image = 'april';
      dialogUtils(
          titleText: 'Miko公仔限时开放预售',
          subtitle: '走在未知的道路上,不许停也不能回头',
          image: image,
          button: '前往预购',
          onTapButton: () {
            closeDialog(
                onClose: () => Utils.openWebSite(
                    'https://www.bilibili.com/blackboard/activity-mikoapril.html'));
          },
          cancelText: '以后再说');
    }
  }
}
