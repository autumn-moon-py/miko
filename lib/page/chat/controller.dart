// ignore_for_file: use_build_context_synchronously

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:miko/model/debug_model.dart';
import 'package:miko/model/user_model.dart';
import 'package:miko/page/chat/chat_view_model.dart';
import 'package:miko/model/message_model.dart';
import 'package:miko/page/debug/debug_view_model.dart';
import 'package:miko/page/setting/setting_view_model.dart';
import 'package:miko/model/trend_model.dart';
import 'package:miko/page/trend/trend_view_model.dart';
import 'package:miko/page/chat/widget.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/notification.dart';
import '../dictionary/dictionary_view_model.dart';
import '../image/image_view_model.dart';

///上下搜索
bool upDownSearch(List tagList, int line, int jump, List story) {
  bool needToNewLine = false;
  for (int j = math.max(0, line - 150); j < line; j++) {
    List lines = story[j];
    String tags = lines[2];
    if (tags.length > 1) {
      List tagsList = tags.split(',');
      if (tagsList.length == 2) {
        String tlStr1 = tagsList[1];
        if (tlStr1.substring(0, 2) == '分支') {
          //左/中,分支XX
          int tlJp = int.parse(tlStr1.substring(2, tlStr1.length));
          if (tlJp == jump) {
            line = j;
            needToNewLine = true;
            break;
          }
        }
      }
    }
  }
  if (needToNewLine) {
    return true;
  }
  return false;
}

///打字等待时间
Future<void> typingTime(String msg, bool waitTyping) async {
  await Future.delayed(
      Duration(seconds: waitTyping ? (msg.length / 4).ceil() : 1));
}

///发送间隔
Future<void> sendInterval(bool waitTyping) async {
  await Future.delayed(Duration(milliseconds: waitTyping ? 700 : 200));
}

void notification(String title, String msg) {
  NotificationService().newNotification(title, msg, false);
}

Future<void> sendLeft(ChatViewModel chatModel, SettingViewModel settingModel,
    String name, String msg) async {
  chatModel.changeTyping(true);
  await typingTime(msg, settingModel.waitTyping);
  chatModel.changeTyping(false);
  if (name != '') chatModel.changeName(name);
  Message message = Message(name, msg, MessageType.left);
  chatModel.addItem(message);
  if (chatModel.isPaused) notification('Miko', msg);
}

Future<void> sendVoice(ChatViewModel chatModel, SettingViewModel settingModel,
    String name, String msg) async {
  chatModel.changeTyping(true);
  await typingTime(msg, settingModel.waitTyping);
  chatModel.changeTyping(false);
  if (name != '') chatModel.changeName(name);
  Message message = Message(name, msg, MessageType.voice);
  chatModel.addItem(message);
  if (chatModel.isPaused) notification('Miko', msg);
}

Future<void> sendImage(ChatViewModel chatModel, SettingViewModel settingModel,
    ImageViewModel imageModel, String image) async {
  String imagePath = 'assets/photo/$image.webp';
  Message message = Message('Miko', '', MessageType.image, image: imagePath);
  imageModel.lockImage(image);
  await sendInterval(settingModel.waitTyping);
  chatModel.addItem(message);
  if (chatModel.isPaused) notification('Miko', '[图片]');
}

Future<void> sendMiddle(
    ChatViewModel chatModel, String msg, SettingViewModel settingModel) async {
  Message message = Message('', msg, MessageType.middle);
  await sendInterval(settingModel.waitTyping);
  chatModel.addItem(message);
}

Future<void> sendRight(
    ChatViewModel chatModel, SettingViewModel settingModel, String msg) async {
  User user = User();
  user.load();
  Message message = Message('', msg, MessageType.right, avatarUrl: user.avatar);
  await sendInterval(settingModel.waitTyping);
  chatModel.addItem(message);
}

Future<void> sendTrend(
    ChatViewModel chatModel,
    ImageViewModel imageModel,
    SettingViewModel settingModel,
    TrendViewModel trendModel,
    String trend,
    String image) async {
  await sendMiddle(chatModel, '对方发布了一条新动态', settingModel);
  imageModel.lockImage(image);
  trendModel.addTrend(Trend(trend, image, DateTime.now()));
  if (chatModel.isPaused) notification('Miko', '[动态]');
}

///播放器
void storyPlayer(BuildContext ctx) async {
  ChatViewModel chatModel = ctx.read<ChatViewModel>();
  SettingViewModel settingModel = ctx.read<SettingViewModel>();
  ImageViewModel imageModel = ctx.read<ImageViewModel>();
  TrendViewModel trendModel = ctx.read<TrendViewModel>();
  DictionaryViewModel dictionaryModel = ctx.read<DictionaryViewModel>();
  String msg = ''; //消息
  List tagList = []; //多标签
  String tag = ''; //单标签
  if (kDebugMode) {
    // chatModel.clearMessage();
    // chatModel.changeLine(1633);
    // chatModel.changeJump(444);
    // chatModel.changeResetLine(1529);
    // chatModel.changeChap('第一章');
  }
  if (chatModel.story.isEmpty) {
    await chatModel.changeStory();
  }
  try {
    do {
      if (chatModel.leftChoose != '' && chatModel.rightChoose != '') {
        debugPrint('有选项');
        break;
      }
      if (settingModel.waitOffline == false) {
        chatModel.changeStartTime(0);
      }
      if (settingModel.waitOffline && chatModel.startTime > 0) {
        debugPrint('已下线');
        if (DateTime.now().millisecondsSinceEpoch > chatModel.startTime) {
          chatModel.changeStartTime(0);
          continue;
        }
        if (DateTime.now().millisecondsSinceEpoch < chatModel.startTime) {
          await Future.delayed(Duration(
              milliseconds: (chatModel.startTime -
                  DateTime.now().millisecondsSinceEpoch)));
          continue;
        }
      }
      List lineInfo = chatModel.story[chatModel.line];
      chatModel.changeLine(chatModel.line + 1);
      //空行继续
      if (lineInfo[2] == '') continue;
      String name = lineInfo[0].toString();
      List story = chatModel.story;
      msg = lineInfo[1].toString();
      tag = lineInfo[2];
      if (tag.length > 1) {
        tagList = tag.split(',');
        tag = '';
      }
      final line = chatModel.line;
      final beJump = chatModel.beJump;
      final jump = chatModel.jump;
      debugPrint('行: $line 分支:$beJump 跳转: $jump 标签: $tag 标签组: $tagList');
      //单标签
      if (tag.isNotEmpty && jump == 0) {
        if (tag == '无') {
          chatModel.changeResetLine(line);
          continue;
        }
        if (tag == '中') {
          await sendMiddle(chatModel, msg, settingModel);
          continue;
        }
        if (tag == '左') {
          await sendLeft(chatModel, settingModel, name, msg);
          continue;
        }
        if (tag == '右') {
          await sendRight(chatModel, settingModel, msg);
          continue;
        }
        if (tag == '图鉴') {
          if (msg.length == 5 && msg.substring(0, 1) != 'W') {
            await sendImage(chatModel, settingModel, imageModel, msg);
          }
          continue;
        }
        if (tag == '动态') {
          await sendTrend(
              chatModel, imageModel, settingModel, trendModel, msg, name);
          continue;
        }
      }
      //多标签
      if (tagList.isNotEmpty) {
        if (tagList[0] == '无' && jump == 0) {
          chatModel.changeResetLine(line);
          continue;
        }
        if (tagList[0] == '语音' && jump == 0) {
          await sendVoice(chatModel, settingModel, name, msg);
          continue;
        }
        if (tagList[0] == '词典' && jump == 0) {
          dictionaryModel.lockDictionary(msg);
          continue;
        }
        if (tagList[0] == 'BE' && jump == 0) {
          if (chatModel.oldChoose.isNotEmpty) {
            chatModel.changeLine(chatModel.oldChoose[0]);
          } else {
            chatModel.changeLine(chatModel.resetLine);
          }
          chatModel.clearMessage();
          EasyLoading.showToast('你已进入BE路线, 自动回溯到五个选项前',
              duration: const Duration(seconds: 3));
          continue;
        }
        if (tagList[0] == '图鉴' && jump == 0) {
          if (msg.length == 5 && msg.substring(0, 1) != 'W') {
            await sendImage(chatModel, settingModel, imageModel, msg);
          } else {
            imageModel.lockImage(msg);
          }
          continue;
        }
        if (tagList[0] == '动态' && jump == 0) {
          await sendTrend(
              chatModel, imageModel, settingModel, trendModel, msg, name);
          continue;
        }
        if (tagList[0] == '左') {
          if (tagList.length == 2) {
            String str = tagList[1];
            if (str.substring(0, 2) == '分支') {
              int beJump0 = int.parse(str.substring(2, str.length));
              chatModel.changeBeJump(beJump0);
              if (beJump0 == jump) {
                //左,分支XX
                chatModel.changeJump(0);
                await sendLeft(chatModel, settingModel, name, msg);
                continue;
              }
            } else if (jump == 0) {
              //左,XX
              chatModel.changeJump(int.parse(tagList[1]));
              await sendLeft(chatModel, settingModel, name, msg);
              if (upDownSearch(tagList, line, jump, chatModel.story)) continue;
            }
          }
          if (tagList.length == 3) {
            //左,XX,分支XX
            String str = tagList[2];
            int beJump0 = int.parse(str.substring(2, str.length));
            chatModel.changeBeJump(beJump0);
            if (beJump0 == jump) {
              int jump0 = int.parse(tagList[1]);
              chatModel.changeJump(jump0);
              chatModel.changeBeJump(0);
              await sendLeft(chatModel, settingModel, name, msg);
              if (upDownSearch(tagList, line, jump, story)) continue;
            }
          }
        }
        if (tagList[0] == '右' && jump == 0 && tagList.length == 3) {
          //右,选项,XX
          if (tagList[1] == '选项' && chatModel.leftChoose == '') {
            chatModel.changeLeftChoose(msg);
            chatModel.addOldChooseItem(line);
            int chooseOneJump = int.parse(tagList[2]);
            chatModel.changeLeftJump(chooseOneJump);
            continue;
          }
          if (tagList[1] == '选项' && chatModel.rightChoose == '') {
            chatModel.changeRightChoose(msg);
            int chooseTwoJump = int.parse(tagList[2]);
            chatModel.changeRightJump(chooseTwoJump);
            break;
          }
        }
        if (tagList[0] == '右' && jump == 0) {
          int jump1 = int.parse(tagList[2]);
          chatModel.changeJump(jump1);
          await sendRight(chatModel, settingModel, msg);
          continue;
        }
        if (tagList[0] == '中') {
          if (tagList.length == 2) {
            //中,分支XX
            String str = tagList[1];
            int beJump1 = int.parse(str.substring(2, str.length));
            chatModel.changeBeJump(beJump1);
            if (beJump1 == jump) {
              chatModel.changeJump(0);
              chatModel.changeBeJump(0);
              await sendMiddle(chatModel, msg, settingModel);
              continue;
            }
          }
          if (tagList.length == 3) {
            //中,XX,分支XX
            String str = tagList[2];
            int beJump2 = int.parse(str.substring(2, str.length));
            chatModel.changeBeJump(beJump2);
            if (beJump2 == beJump) {
              str = tagList[1];
              int jump2 = int.parse(str);
              chatModel.changeJump(jump2);
              chatModel.changeBeJump(0);
              await sendMiddle(chatModel, msg, settingModel);
              if (upDownSearch(tagList, line, jump, story)) continue;
            }
          }
          if (tagList.length == 4 && jump == 0) {
            //中,XX,等待,XX
            if (tagList[1] != 0) {
              int jump3 = int.parse(tagList[1]);
              chatModel.changeJump(jump3);
              if (upDownSearch(tagList, line, jump, story)) continue;
            }
            int startTime = DateTime.now().millisecondsSinceEpoch +
                int.parse(tagList[3]) * 60000;
            chatModel.changeStartTime(startTime);
            continue;
          }
        }
      }
    } while (chatModel.line < chatModel.story.length);
  } catch (e) {
    EasyLoading.showError('捕获到异常，请前往异常日志查看');
    DebugInfo debugInfo = DebugInfo();
    debugInfo.beJump = chatModel.beJump;
    debugInfo.error = e.toString();
    debugInfo.jump = chatModel.jump;
    debugInfo.line = chatModel.line;
    debugInfo.time = DateTime.now().toString();
    debugInfo.version = await Utils.getVersion();
    debugInfo.chapter = chatModel.chapter;
    debugInfo.jpushID = await Utils.getJPushID();
    ctx.read<DebugViewModel>().addItem(debugInfo);
  }
  debugPrint('退出播放');
}
