import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

//判断是否在移动端的方法
bool isMobile() {
  return GetPlatform.isAndroid;
}

class MyTheme {
  static Color background = const Color.fromRGBO(31, 31, 41, 1);
  static Color foreground = const Color.fromRGBO(37, 39, 51, 1);
  static Color background51 = const Color.fromRGBO(37, 39, 51, 1);
  static Color foreground62 = const Color.fromRGBO(48, 50, 62, 1);
  static TextStyle miniStyle =
      TextStyle(color: Colors.white, fontSize: isMobile() ? 35.sp : 20.sp);
  static TextStyle narmalStyle =
      TextStyle(color: Colors.white, fontSize: isMobile() ? 45.sp : 25.sp);
  static TextStyle bigStyle =
      TextStyle(color: Colors.white, fontSize: isMobile() ? 50.sp : 30.sp);
  static double minIconSize = isMobile() ? 75.r : 95.r;
  static double narmalIconSize = isMobile() ? 80.r : 100.r;
  static double bigIconSize = isMobile() ? 95.r : 115.r;
}
