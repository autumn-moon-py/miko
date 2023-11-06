import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

///读取剧本
Future<List> loadCVS(String chapter) async {
  //报错检查csv编码是否为utf-8
  final rawData = await rootBundle.loadString(
    "assets/story/$chapter.csv",
  );
  final result = const CsvToListConverter().convert(rawData, eol: '\r\n'); //win
  // final result = const CsvToListConverter().convert(rawData, eol: '\n'); //mac
  return result;
}
