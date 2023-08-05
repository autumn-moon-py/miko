import 'package:flutter/material.dart';
import 'package:miko/model/debug_model.dart';
import 'package:miko/page/chat/chat_view_model.dart';
import 'package:miko/page/debug/debug_view_model.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:provider/provider.dart';

import '../../theme/color.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Widget _debugWidget(
      {required Widget body,
      required List<Widget> acitons,
      required Widget background}) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: MyTheme.foreground,
            actions: acitons,
            title: const Text('异常日志')),
        body: Stack(children: [background, body]));
  }

  Widget _buildBackground() {
    return Stack(children: [
      Container(color: MyTheme.background),
      const Center(
          child: Text('提示：单击日志列表可复制到粘贴板',
              style: TextStyle(color: Colors.grey, fontSize: 20)))
    ]);
  }

  Widget _buildListItem(int index, DebugInfo debugInfo) {
    final line = debugInfo.line;
    final beJump = debugInfo.beJump;
    final jump = debugInfo.jump;
    final tag = debugInfo.tag;
    final msg = debugInfo.msg;
    final error = debugInfo.error;
    final version = debugInfo.version;
    final time = debugInfo.time;
    final maxWidth = MediaQuery.of(context).size.width - 50;
    const style = TextStyle(color: Colors.white, fontSize: 15);
    return GestureDetector(
        onTap: () => debugInfo.copy(),
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Text(index.toString(), style: style.copyWith(fontSize: 20)),
              const SizedBox(width: 10),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Text(
                      '行: $line,分支: $beJump,跳转: $jump\r\n标签: $tag\r\n气泡: $msg\r\n异常: $error\r\n版本: $version\r\n时间: $time',
                      style: style))
            ])));
  }

  Widget _buildBody() {
    final debug = context.watch<DebugViewModel>().debugList;
    return ListView.builder(
        itemCount: debug.length,
        padding: const EdgeInsets.all(10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) => _buildListItem(index, debug[index]));
  }

  List<Widget> _buildActions() {
    final model = context.read<DebugViewModel>();
    final chatModel = context.read<ChatViewModel>();
    return [
      IconButton(
          onPressed: () async {
            DebugInfo debugInfo = DebugInfo();
            debugInfo.beJump = chatModel.beJump;
            debugInfo.error = '反馈时额外备注';
            debugInfo.jump = chatModel.jump;
            debugInfo.line = chatModel.line;
            debugInfo.msg = chatModel.story[chatModel.line][1];
            debugInfo.tag = chatModel.story[chatModel.line][2];
            debugInfo.time = DateTime.now().toString();
            debugInfo.version = await Utils.getVersion();
            model.addItem(debugInfo);
          },
          icon: const Icon(Icons.add)),
      IconButton(
          onPressed: () => model.cleanDebugList(),
          icon: const Icon(Icons.delete))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _debugWidget(
        background: _buildBackground(),
        acitons: _buildActions(),
        body: _buildBody());
  }
}
