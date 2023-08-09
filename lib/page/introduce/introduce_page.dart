import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miko/page/chat/chat_page.dart';
import 'package:miko/theme/color.dart';

class IntroducePage extends StatefulWidget {
  const IntroducePage({super.key});

  @override
  State<IntroducePage> createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  final PageController _pageController = PageController();
  final List<String> _children = ['聊天页', '动态页', '词典页', '图鉴页', '章节页'];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _previousButton(int index) {
    return GestureDetector(
        onTap: () {
          _pageController.animateToPage(index - 1,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn);
        },
        child: Container(
            width: 1.sw / 3,
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.arrow_back_ios,
                color: Colors.white, size: 50)));
  }

  Widget _nextButton(int index) {
    return GestureDetector(
        onTap: () {
          if (index == _children.length - 1) {
            Get.off(const ChatPage());
          } else {
            _pageController.animateToPage(index + 1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn);
          }
        },
        child: Container(
            width: 1.sw / 3,
            color: Colors.transparent,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.arrow_forward_ios_outlined,
                color: Colors.white, size: 50)));
  }

  Widget _button(int index) {
    if (index == 0) {
      return Row(
          children: [const Expanded(child: SizedBox()), _nextButton(index)]);
    }
    if (index > 0) {
      return Row(children: [
        _previousButton(index),
        const Expanded(child: SizedBox()),
        _nextButton(index)
      ]);
    }
    return _previousButton(index);
  }

  Widget _showImage(String image) {
    return SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Image.asset('assets/images/$image.webp', fit: BoxFit.cover));
  }

  Widget _tips(int index) {
    const tipList = [
      '这是一款充满冒险与刺激的文字对话互动应用。应用虚拟一位陌生人给你实时传送信息，而你将决定主角的命运。因完全采用模拟现实通讯，所以请注意你的消息，主角随时可能需要你的帮助。另外主角也需要睡眠时间以及活动时间(没有固定时间)，你需要等候主角上线才能继续进行对话交流\r\n如果不想等待主角上线可以去设置关闭下线时间，主角下线会立刻上线\r\n本游戏原本为睿果工作室开发，后续因为某些问题下架，秋月重新制作了该版本\r\n由于剧本是由秋月重新手打，剧情跟原本的会有偏差，请知悉，然后不要在群聊继续提起\r\n因为以上原因，原本网上的攻略可能并不适用\r\n设置按钮旁边的是跳转天数，点击后弹出弹窗，点击第X天跳转到剧本的第X天开头，没有二次确认，谨慎点击\r\n进入BE路线后会自动回溯到三个选项前，也有可能回溯到当天初始',
      '没啥修改',
      '词典有修改，详情请看www.subrecovery.top的各版本介绍',
      '图鉴有修改，详情请看www.subrecovery.top的各版本介绍，还有部分的图鉴用AI重绘了，质感更好，微博系列图鉴在每一章结尾获取',
      '我们还自制了一个同人章节：番外三'
    ];

    return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                width: 1.sw / 1.5,
                color: Colors.black.withAlpha(150),
                padding: const EdgeInsets.all(10),
                child: Text(tipList[index], style: MyTheme.narmalStyle))));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: _children.length,
        itemBuilder: (_, index) {
          return Stack(children: [
            _showImage(_children[index]),
            _button(index),
            _tips(index)
          ]);
        });
  }
}
