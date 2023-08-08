import 'dart:convert';

import 'package:miko/model/message_model.dart';
import 'package:miko/page/chat/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'trend_model.dart';

class User {
  String avatar = '';
  String name = '';
  String chapter = '第一章';
  int playLine = 0;
  List<Message> oldMessage = [];
  List<Trend> oldTrend = [];
  late SharedPreferences prefs;

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    avatar = prefs.getString('avatar') ?? avatar;
    name = prefs.getString('name') ?? name;
    playLine = prefs.getInt('playLine') ?? playLine;
    chapter = prefs.getString('chapter') ?? chapter;
    loadMessage(prefs.getStringList('oldMessage') ?? []);
  }

  Future<void> loadTrend() async {
    prefs = await SharedPreferences.getInstance();
    List<String> trendList = prefs.getStringList('oldTrend') ?? [];
    if (trendList.isNotEmpty) loadTrendList(trendList);
  }

  Future<Map> loadImage(Map imageMap) async {
    prefs = await SharedPreferences.getInstance();
    final result = prefs.getString('imageMap') ?? '';
    if (result.isEmpty) return imageMap;
    Map imgMap = jsonDecode(result);
    return imgMap;
  }

  Future<Map> loadDic(Map dictionaryMap) async {
    prefs = await SharedPreferences.getInstance();
    final dicList = prefs.getStringList('dictionaryMap') ?? [];
    for (var item in dicList) {
      List dic = item.split(':');
      dictionaryMap[dic[0]][1] = dic[1];
    }
    return dictionaryMap;
  }

  Future<void> save() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', avatar);
    prefs.setString('name', name);
    prefs.setString('chapter', chapter);
    prefs.setInt('playLine', playLine);
    prefs.setStringList('oldMessage', saveMessage());
  }

  Future<void> saveTrend() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList('oldTrend', saveTrendList());
  }

  Future<void> saveImage(Map imageMap) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('imageMap', jsonEncode(imageMap));
  }

  Future<void> saveDic(Map dictionaryMap) async {
    prefs = await SharedPreferences.getInstance();
    List<String> dictionaryList = [];
    dictionaryMap.forEach((key, value) {
      dictionaryList.add('$key:${value[1]}');
    });
    prefs.setStringList('dictionaryMap', dictionaryList);
  }

  List<String> saveMessage() {
    List<String> messageList = [];
    for (var message in oldMessage) {
      messageList.add(message.toString());
    }
    return messageList;
  }

  void loadMessage(List<String> messageList) {
    if (messageList.isEmpty) return;
    for (var json in messageList) {
      Message message = Message('', '', MessageType.left);
      message.fromString(json);
      oldMessage.add(message);
    }
  }

  List<String> saveTrendList() {
    List<String> trendList = [];
    for (var trend in oldTrend) {
      trendList.add(trend.toString());
    }
    return trendList;
  }

  void loadTrendList(List<String> trendList) {
    for (var json in trendList) {
      Trend trend = Trend('', '', DateTime.now());
      trend.fromString(json);
      oldTrend.add(trend);
    }
  }
}
