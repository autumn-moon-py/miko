import 'package:flutter/material.dart';
import 'package:miko/page/about/about_page.dart';
import 'package:miko/page/chapter/chapter_page.dart';
import 'package:miko/page/chat/chat_page.dart';
import 'package:miko/page/debug/debug_page.dart';
import 'package:miko/page/dictionary/dictionary_page.dart';
import 'package:miko/page/load/load_page.dart';
import 'package:miko/page/setting/setting_page.dart';
import 'package:miko/page/trend/trend_page.dart';

import '../page/dictionary/widget.dart';
import '../page/image/image_page.dart';
import '../page/image/widget.dart';

class MyRoute {
  static final routes = {
    '/load': (context) => const LoadPage(),
    '/chat': (context) => const ChatPage(),
    '/trend': (context) => const TrendPage(),
    '/image': (context) => const ImagePage(),
    '/dic': (context) => const DictionaryPage(),
    '/image_view': (context) => const ImageView(),
    '/dic_view': (context) => const DictionaryView(),
    '/setting': (context) => const SettingPage(),
    '/chapter': (context) => const ChapterPage(),
    '/about': (context) => const AboutPage(),
    '/debug': (context) => const DebugPage(),
  };
  static void to(BuildContext context, String name, [Object? arg]) {
    Navigator.pushNamed(context, name, arguments: arg);
  }

  static void back(BuildContext context) {
    Navigator.of(context).pop(context);
  }
}
