import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugInfo {
  int line = 0;
  int beJump = 0;
  int jump = 0;
  String tag = '';
  String msg = '';
  String error = '';
  String version = '';
  String time = '';

  @override
  String toString() {
    return jsonEncode([line, beJump, jump, tag, msg, error, version, time]);
  }

  DebugInfo fromString(String json) {
    final debugInfoList = jsonDecode(json);
    DebugInfo debug = DebugInfo();
    debug.line = debugInfoList[0];
    debug.beJump = debugInfoList[1];
    debug.jump = debugInfoList[2];
    debug.tag = debugInfoList[3];
    debug.msg = debugInfoList[4];
    debug.error = debugInfoList[5];
    debug.version = debugInfoList[6];
    debug.time = debugInfoList[7];
    return debug;
  }

  void copy() {
    final debug =
        '行: $line,分支: $beJump,跳转: $jump\r\n标签: $tag\r\n气泡: $msg\r\n异常: $error\r\n版本: $version\r\n时间: $time';
    Clipboard.setData(ClipboardData(text: debug));
    EasyLoading.showToast('复制成功');
  }
}

class Debug {
  late SharedPreferences prefs;
  final List<DebugInfo> debugList = [];
  Future<void> save() async {
    prefs = await SharedPreferences.getInstance();
    List<String> debugStringList = [];
    for (var item in debugList) {
      debugStringList.add(item.toString());
    }
    prefs.setStringList('debugList', debugStringList);
  }

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    List<String> debugStringList = prefs.getStringList('debugList') ?? [];
    if (debugStringList.isNotEmpty) {
      for (var item in debugStringList) {
        DebugInfo debug = DebugInfo().fromString(item);
        debugList.add(debug);
      }
    }
  }
}
