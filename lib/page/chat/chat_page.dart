import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:miko/theme/color.dart';
import 'package:miko/utils/routes.dart';

import '../../utils/app_utils.dart';
import '../../widget.dart';
import 'controller.dart';
import 'widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.init(context);
      storyPlayer(context);
      debugPrint('聊天初始化');
    });
  }

  Widget _buildTitle() {
    return const TitleWidget();
  }

  Widget _buildBody() {
    return const ChatList();
  }

  Widget _buildChooseButton() {
    return const ChooseButton();
  }

  Widget _buildBackground() {
    return Blur(
        blurColor: Colors.transparent,
        blur: 1.5,
        colorOpacity: 0.2,
        child: Image.asset('assets/images/聊天背景.webp',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover));
  }

  Widget _buildSettingButton() {
    return IconButton(
        onPressed: () {
          MyRoute.to(context, '/setting');
        },
        icon: const Icon(Icons.settings, color: Colors.white, size: 30));
  }

  Widget _buildDrawer() {
    Widget item(
        {required IconData leading,
        required String title,
        required Function onTap}) {
      return Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).closeDrawer();
            onTap.call();
          },
          child: ListTile(
              leading: Icon(leading, color: Colors.grey, size: 30),
              title: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.grey, size: 20)),
        );
      });
    }

    return Stack(children: [
      cilpWidget(
          width: 1080,
          height: 500,
          yOffset: -1200,
          child: Image.asset('assets/images/聊天背景.webp')),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        item(
            leading: Icons.photo,
            title: '图鉴',
            onTap: () => MyRoute.to(context, '/image')),
        item(
            leading: Icons.type_specimen,
            title: '词典',
            onTap: () => MyRoute.to(context, '/dic')),
        item(
            leading: Icons.menu_book_rounded,
            title: '章节',
            onTap: () => MyRoute.to(context, '/chapter')),
        item(
            leading: Icons.info_outline_rounded,
            title: '关于',
            onTap: () => MyRoute.to(context, '/about'))
      ])
    ]);
  }

  Widget _buildJumpDayButton() {
    return IconButton(
        onPressed: () {
          jumpDayDialog(context);
        },
        icon: const Icon(Icons.date_range, color: Colors.white, size: 30));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('构建页面');
    return HomeWidget(
        leadingIcon: Icons.menu,
        appbarColor: MyTheme.foreground,
        leadingIconSize: 30,
        drawer: _buildDrawer(),
        title: _buildTitle(),
        actions: [_buildJumpDayButton(), _buildSettingButton()],
        body: _buildBody(),
        toLast: const ToLast(),
        background: _buildBackground(),
        bottom: _buildChooseButton());
  }
}
