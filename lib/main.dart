import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miko/page/debug/debug_view_model.dart';
import 'package:miko/utils/routes.dart';
import 'package:provider/provider.dart';

import 'page/chat/chat_view_model.dart';
import 'page/dictionary/dictionary_view_model.dart';
import 'page/image/image_view_model.dart';
import 'page/setting/setting_view_model.dart';
import 'page/trend/trend_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatViewModel>(create: (_) => ChatViewModel()),
          ChangeNotifierProvider<DictionaryViewModel>(
              create: (_) => DictionaryViewModel()),
          ChangeNotifierProvider<ImageViewModel>(
              create: (_) => ImageViewModel()),
          ChangeNotifierProvider<ImageViewModel>(
              create: (_) => ImageViewModel()),
          ChangeNotifierProvider<SettingViewModel>(
              create: (_) => SettingViewModel()),
          ChangeNotifierProvider<TrendViewModel>(
              create: (_) => TrendViewModel()),
          ChangeNotifierProvider<DebugViewModel>(
              create: (_) => DebugViewModel()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, _) {
              return GetMaterialApp(
                  title: '异次元通讯',
                  theme: ThemeData().copyWith(useMaterial3: false),
                  debugShowCheckedModeBanner: false,
                  builder: EasyLoading.init(),
                  initialRoute: '/load',
                  routes: MyRoute.routes);
            }));
  }
}
