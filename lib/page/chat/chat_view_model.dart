// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:miko/page/chat/controller.dart';
import 'package:miko/utils/chat_utils.dart';

import '../../model/message_model.dart';
import '../../model/user_model.dart';

class ChatViewModel with ChangeNotifier {
  String _name = '';
  final List<Message> _message = [];
  final List<List> _story = [];
  bool _showChoose = false;
  String _leftChoose = '';
  int _leftJump = 0;
  int _rightJump = 0;
  String _rightChoose = '';
  bool _typing = false;
  int _startTime = 0;
  int _line = 0;
  int _beJump = 0;
  int _jump = 0;
  int _resetLine = 0;
  String _chapter = '第一章';
  String _avatarUrl = '';
  final user = User();
  final ScrollController chatController = ScrollController();

  Future<void> init() async {
    await user.load();
    _avatarUrl = user.avatar;
    _line = user.playLine;
    _name = user.name;
    _message.addAll(user.oldMessage);
    _chapter = user.chapter;
    debugPrint('读取聊天历史');
  }

  void changeAvatarUrl(String avatarUrl) {
    _avatarUrl = avatarUrl;
    user.avatar = _avatarUrl;
    user.save();
    notifyListeners();
  }

  String get avatarUrl => _avatarUrl;

  Future<void> changeChapter(String chapter, BuildContext context) async {
    _chapter = chapter;
    _message.clear();
    _story.clear();
    _leftChoose = '';
    _leftJump = 0;
    _rightChoose = '';
    _rightJump = 0;
    _jump = 0;
    _line = 0;
    _beJump = 0;
    _resetLine = 0;
    _showChoose = false;
    _startTime = 0;
    user.chapter = _chapter;
    user.save();
    await changeStory();
    notifyListeners();
    storyPlayer(context);
  }

  String get chapter => _chapter;

  void changeLeftJump(int jump) => _leftJump = jump;

  int get leftJump => _leftJump;

  void changeRightJump(int jump) {
    _rightJump = jump;
    _showChoose = true;
  }

  int get rightJump => _rightJump;

  void changeResetLine(int resetLine) => _resetLine = resetLine;

  int get resetLine => _resetLine;

  void changeJump(int jump) => _jump = jump;

  int get jump => _jump;

  void changeBeJump(int beJump) => _beJump = beJump;

  int get beJump => _beJump;

  void changeLine(int line) => _line = line;

  int get line => _line;

  Future<void> changeStory() async {
    _story.clear();
    List<List> story0 = await loadCVS(chapter) as List<List>;
    _story.addAll(story0);
  }

  List<List> get story => _story;

  void changeName(String name) {
    _name = name;
    notifyListeners();
  }

  void addItem(Message item) {
    _message.add(item);
    notifyListeners();
    user.playLine = _line;
    user.oldMessage = _message;
    user.name = _name;
    user.save();
    Future.delayed(const Duration(milliseconds: 100), () {
      chatController.jumpTo(chatController.position.maxScrollExtent);
    });
  }

  void clearMessage() {
    _message.clear();
    notifyListeners();
  }

  void changeShowChoose(bool showChoose) {
    if (!showChoose) {
      _leftChoose = '';
      _rightChoose = '';
    }
    _showChoose = showChoose;
    notifyListeners();
  }

  void changeLeftChoose(String leftChoose) {
    _leftChoose = leftChoose;
    notifyListeners();
  }

  void changeRightChoose(String rightChoose) {
    _rightChoose = rightChoose;
    notifyListeners();
  }

  void changeTyping(bool typing) {
    _typing = typing;
    notifyListeners();
  }

  void changeStartTime(int startTime) => _startTime = startTime;

  String get name => _name;
  List<Message> get message => _message;
  bool get showChoose => _showChoose;
  String get leftChoose => _leftChoose;
  String get rightChoose => _rightChoose;
  bool get typing => _typing;
  int get startTime => _startTime;
}
