import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:miko/page/introduce/introduce_page.dart';
import 'package:miko/page/setting/setting_view_model.dart';
import 'package:miko/theme/color.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:miko/utils/routes.dart';
import 'package:provider/provider.dart';

import '../../widget.dart';
import '../chat/chat_view_model.dart';

class SettingBody extends StatefulWidget {
  const SettingBody({super.key});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  Widget _buildBody({required List<Widget> children}) {
    return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        children: children);
  }

  Widget _buildDebugButton() {
    return buildCard(children: [
      buildDefaultItem(
          leading: Icons.error,
          title: '异常日志',
          onTap: () => MyRoute.to(context, '/debug')),
      buildDefaultItem(
          leading: Icons.list_alt,
          title: '异常反馈',
          onTap: () {
            Utils.openWebSite(
                'https://docs.qq.com/form/page/DVVZJa1hQY3BtZnlw');
          })
    ]);
  }

  Widget _buildMusicButton() {
    final model = context.read<SettingViewModel>();
    final bgm = context.watch<SettingViewModel>().bgm;
    final buttonMusic = context.watch<SettingViewModel>().buttonMusic;
    final oldBgm = context.watch<SettingViewModel>().oldBgm;
    final voice = context.watch<SettingViewModel>().voice;
    return buildCard(children: [
      buildDefaultItem(
          leading: Icons.music_note,
          title: '背景音乐',
          button: Switch(
              value: bgm,
              onChanged: (value) {
                model.changeBgm(value);
              })),
      buildDefaultItem(
          leading: Icons.music_note,
          title: '旧版音乐',
          button: Switch(
              value: oldBgm,
              onChanged: (value) {
                model.changeOldBgm(value);
              })),
      buildDefaultItem(
          leading: Icons.music_note_outlined,
          title: '按钮音效',
          button: Switch(
              value: buttonMusic,
              onChanged: (value) {
                model.changeButtonMusic(value);
              })),
      buildDefaultItem(
          leading: Icons.voice_chat,
          title: '语音开关',
          button: Switch(
              value: voice,
              onChanged: (value) {
                model.changeVoice(value);
                shuffixVoice(value);
              })),
    ]);
  }

  void shuffixVoice(bool voice) {
    if (!voice) {
      if (voicePlayer.playing) voicePlayer.pause();
      return;
    }
    final random = Random();
    double probability = 0.3;
    if (random.nextDouble() < probability) {
      final randomVoice = random.nextInt(2);
      if (randomVoice == 0) {
        voicePlayer.setAsset('assets/music/听得见吗.ogg');
      }
      if (randomVoice == 1) {
        voicePlayer.setAsset('assets/music/喂.ogg');
      }
      if (randomVoice == 2) {
        voicePlayer.setAsset('assets/music/我在哦.ogg');
      }
      voicePlayer.setVolume(0.5);
      if (!voicePlayer.playing) voicePlayer.play();
    }
  }

  Widget _buildChatButton() {
    final model = context.read<SettingViewModel>();
    final waitTyping = context.watch<SettingViewModel>().waitTyping;
    final waitOffline = context.watch<SettingViewModel>().waitOffline;
    return buildCard(children: [
      buildDefaultItem(
          leading: Icons.keyboard,
          title: '打字时间',
          button: Switch(
              value: waitTyping,
              onChanged: (value) {
                model.changeWaitTyping(value);
              })),
      buildDefaultItem(
          leading: Icons.timelapse,
          title: '下线时间',
          button: Switch(
              value: waitOffline,
              onChanged: (value) {
                model.changeWaitOffline(value);
              }))
    ]);
  }

  Widget _buildAvatarButton() {
    final model = context.read<SettingViewModel>();
    final nowMikoAvatar = context.watch<SettingViewModel>().nowMikoAvatar;
    final userModel = context.watch<ChatViewModel>();
    final playAvatar = userModel.avatarUrl;
    return buildCard(children: [
      buildDefaultItem(
          leading: Icons.person_2,
          title: 'Miko头像',
          button: DropdownButton(
              value: nowMikoAvatar,
              iconEnabledColor: Colors.white,
              underline: const Divider(),
              style: const TextStyle(color: Colors.white, fontSize: 25),
              dropdownColor: MyTheme.foreground62,
              items: List.generate(
                  8,
                  (index) => DropdownMenuItem(
                      value: index + 1,
                      alignment: Alignment.center,
                      child: Image.asset('assets/icon/头像${index + 1}.webp',
                          width: 35))),
              onChanged: (value) {
                model.changeNowMikoAvatar(value ?? 1);
              })),
      buildDefaultItem(
          leading: Icons.person,
          title: '玩家头像',
          subTitle: "点击设置玩家头像",
          onTap: () {
            String avatarUrl = '';
            Get.dialog(AlertDialog(
                backgroundColor: MyTheme.foreground62,
                title:
                    const Text('请输入QQ号', style: TextStyle(color: Colors.white)),
                content: TextField(
                    style: MyTheme.narmalStyle,
                    onChanged: (value) {
                      avatarUrl = 'http://q1.qlogo.cn/g?b=qq&nk=$value&s=100';
                    }),
                actions: [
                  TextButton(
                      onPressed: () {
                        userModel.changeAvatarUrl('');
                        Get.back();
                      },
                      child: const Text('清除')),
                  TextButton(
                      onPressed: () async {
                        Get.back();
                        if (avatarUrl.isEmpty) return;
                        userModel.changeAvatarUrl(avatarUrl);
                      },
                      child: const Text('确定'))
                ]));
          },
          button: playAvatar.isEmpty
              ? Image.asset('assets/icon/未知用户.webp', width: 40)
              : ClipOval(
                  child: Image.network(playAvatar, width: 35,
                      errorBuilder: (context, error, stackTrace) {
                  EasyLoading.showError('设置头像失败: $error');
                  return Image.asset('assets/icon/未知用户.webp', width: 40);
                })))
    ]);
  }

  Widget _buildTips() {
    return DefaultTextStyle(
        style: MyTheme.miniStyle.copyWith(color: Colors.yellow),
        child: buildCard(padding: true, addLine: false, children: [
          const Text('1.剧情不播放时，请反馈，看[2]'),
          const Text('2.进入异常日志添加记录复制记录再点开异常反馈填表'),
          const Text('3.别私信秋月'),
          const Text('4.不建议在平台在线游玩,可以前往官网（菜单-关于）下载本地应用'),
          const Text('5.如有其它问题请前往Q群询问')
        ]));
  }

  Widget _buildIntroduceButton() {
    return buildCard(children: [
      buildDefaultItem(
          leading: Icons.start,
          title: '游戏介绍',
          onTap: () => Get.to(const IntroducePage()))
    ]);
  }

  Widget _buildNewImage() {
    final model = context.read<SettingViewModel>();
    final newIMage = context.watch<SettingViewModel>().newImage;
    return buildCard(children: [
      buildDefaultItem(
          leading: Icons.photo,
          title: 'AI图鉴',
          button: Switch(
              value: newIMage,
              onChanged: (value) => model.changeNewImage(value, context)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Widget padding = const SizedBox(height: 15);
    return _buildBody(children: [
      _buildTips(),
      padding,
      _buildIntroduceButton(),
      padding,
      _buildDebugButton(),
      padding,
      _buildAvatarButton(),
      padding,
      _buildNewImage(),
      padding,
      _buildMusicButton(),
      padding,
      _buildChatButton(),
      padding
    ]);
  }
}
