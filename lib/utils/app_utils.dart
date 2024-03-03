import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miko/page/setting/setting_view_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:url_launcher/url_launcher.dart';

bool taptap = false;

AudioPlayer bgmPlayer = AudioPlayer();
AudioPlayer buttonPlayer = AudioPlayer();
AudioPlayer voicePlayer = AudioPlayer();
List<String> baseUrl = [
  'https://subrecovery.top',
  'https://www.subrecovery.top',
  'https://app.subrecovery.top',
  'https://subrecovery.netlify.app'
];

class Utils {
  ///初始化
  static Future<void> init(BuildContext context) async {
    getVersion();
    checkConnect();
    setBackground();
    requestPermission();
    requestNotification();
    audioInit(context);
    privacyDialog(context);
  }

  ///隐私政策
  static Future<void> privacyDialog(BuildContext context) async {
    if (!taptap) return;
    if (kDebugMode || Platform.isWindows) return;
    final privacy = context.read<SettingViewModel>().privacy;
    if (privacy) return;
    Get.dialog(AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 220),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: const Text('隐私政策'),
        content: const Text(
            '本应用不会收集您的任何信息，也不会上传您的任何信息，如果您同意本应用的隐私政策，请点击同意按钮，否则请点击不同意按钮'),
        actions: [
          TextButton(
              onPressed: () {
                final url =
                    Uri.parse('https://www.subrecovery.top/privacy.html');
                launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
              },
              child: const Text('隐私政策')),
          TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                '不同意',
                style: TextStyle(color: Colors.grey),
              )),
          TextButton(
              onPressed: () {
                context.read<SettingViewModel>().changePrivacy(true);
                Get.back();
              },
              child: const Text('同意'))
        ]));
  }

  ///获取版本号
  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  ///请求通知
  static Future<void> requestNotification() async {
    if (kDebugMode || Platform.isWindows || Platform.isMacOS || taptap) return;
    final notificationStatus = await Permission.notification.status;
    if (notificationStatus.isDenied) {
      final result = await Permission.notification.request();
      EasyLoading.showInfo("通知：${result.isGranted ? '已授权' : '未授权'}");
    } else {
      EasyLoading.showInfo("通知：未授权，请自行前往设置打开通知");
    }
  }

  ///请求权限
  static Future<void> requestPermission() async {
    if (taptap || kDebugMode || Platform.isWindows) return;
    final installPackagesStatus =
        await Permission.requestInstallPackages.status;
    if (installPackagesStatus.isDenied) {
      Get.dialog(AlertDialog(title: const Text('自动更新需要授权允许安装未知应用'), actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('取消', style: TextStyle(color: Colors.grey))),
        TextButton(
            onPressed: () async {
              await Permission.requestInstallPackages.request();
              Get.back();
            },
            child: const Text('确定'))
      ]));
    }
  }

  ///后台运行设置
  static Future<void> setBackground() async {
    if (taptap || kDebugMode || Platform.isWindows) return;
    bool success = await FlutterBackground.initialize(
        androidConfig: const FlutterBackgroundAndroidConfig());
    if (success) {
      await FlutterBackground.enableBackgroundExecution();
    }
  }

  ///请求网络
  static Future<void> checkConnect() async {
    if (taptap || kDebugMode || Platform.isWindows) return;
    checkUpgrade();
  }

  ///检查更新
  static Future<void> checkUpgrade() async {
    final version = await getVersion();
    final dio = Dio();
    int statusCode = 0;
    for (var url in baseUrl) {
      try {
        final response = await dio.get('$url/app/new/upgrade.json');
        statusCode = response.statusCode!;
        if (statusCode == 200) {
          final result = jsonDecode(response.toString());
          if (result['version'] != version) {
            EasyLoading.showInfo(
              '${result['version']}\r\n有新版本,请更新\r\n${result['info']}',
              duration: const Duration(seconds: 5),
            );
            await upgrade(result['version']);
          }
          break;
        }
      } catch (e) {
        EasyLoading.showError('检查更新失败,异常：$e');
      }
    }
  }

  ///更新
  static Future<void> upgrade(String version) async {
    EasyLoading.showToast('开始更新');
    const headers = {
      'User-Agent': 'chatapp/(Android;com.example.sub.chatapp) Flutter'
    };
    String fileName = 'app-release-$version.apk';
    for (var url in baseUrl) {
      String apkUrl = '$url/app/new/app-release-$version.apk';
      final apkSize = await RUpgrade.upgrade(apkUrl,
              header: headers,
              installType: RUpgradeInstallType.normal,
              fileName: fileName) ??
          0;
      if (apkSize > 0) {
        EasyLoading.showToast('更新完成');
        break;
      }
    }
  }

  ///下载图片
  static Future<void> downloadImage(String imageName) async {
    try {
      ByteData imageData =
          await rootBundle.load('assets/photo/$imageName.webp');
      final result = await ImageGallerySaver.saveImage(
          imageData.buffer.asUint8List(),
          name: imageName,
          quality: 100);
      if (result['isSuccess']) {
        EasyLoading.showToast('保存完成',
            toastPosition: EasyLoadingToastPosition.bottom);
      } else {
        EasyLoading.showError('保存失败');
      }
    } catch (_) {
      EasyLoading.showError('保存异常');
    }
  }

  ///初始化音频
  static void audioInit(BuildContext context) {
    if (taptap || kDebugMode || Platform.isWindows) return;
    final oldBgm = context.read<SettingViewModel>().oldBgm;
    if (oldBgm) {
      bgmPlayer.setAsset('assets/music/oldBgm.ogg');
    } else {
      bgmPlayer.setAsset('assets/music/bgm.ogg');
    }
    bgmPlayer.setLoopMode(LoopMode.one);
    bgmPlayer.setVolume(0.5);
    buttonPlayer.setAsset('assets/music/button.ogg');
    bool playBgm = context.read<SettingViewModel>().bgm;
    if (playBgm) bgmPlayer.play();
  }

  ///访问网站
  static Future<void> openWebSite(String url) async {
    await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication);
  }
}
