import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miko/page/chat/controller.dart';
import 'package:miko/page/setting/setting_view_model.dart';
import 'package:miko/theme/color.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:miko/utils/routes.dart';
import 'package:provider/provider.dart';

import '../dictionary/dictionary_view_model.dart';
import 'chat_view_model.dart';
import '../../model/message_model.dart';

class HomeWidget extends StatelessWidget {
  final IconData leadingIcon;
  final Color? leadingIconColor;
  final double? leadingIconSize;
  final Widget title;
  final List<Widget> actions;
  final Widget? background;
  final Widget body;
  final Widget bottom;
  final Color? appbarColor;
  final Widget? toLast;
  final Widget drawer;
  const HomeWidget(
      {super.key,
      required this.leadingIcon,
      this.leadingIconColor,
      this.leadingIconSize,
      required this.title,
      required this.actions,
      this.background,
      required this.body,
      required this.bottom,
      this.appbarColor,
      this.toLast,
      required this.drawer});

  Widget _buildBackGround(Widget? background) {
    return background ?? const SizedBox();
  }

  Widget _buildToLast() {
    return toLast ?? const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appbarColor,
            centerTitle: true,
            leading: Builder(builder: (context) {
              return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Icon(leadingIcon,
                      color: leadingIconColor ?? Colors.white,
                      size: leadingIconSize ?? 40));
            }),
            title: title,
            actions: actions),
        drawer: Drawer(
          backgroundColor: MyTheme.background51,
          child: drawer,
        ),
        body: Stack(children: [
          Container(color: MyTheme.background51),
          _buildBackGround(background),
          Column(children: [Expanded(child: body), bottom]),
          _buildToLast()
        ]));
  }
}

enum MessageType { left, image, middle, right, voice }

abstract class Bubble extends StatelessWidget {
  final String? text;
  final Widget? avatar;
  final Function(BuildContext)? avatarCallback;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsets? avatarMargin;
  final EdgeInsets? textPadding;
  final double? avatarSize;

  const Bubble(
      {Key? key,
      this.text,
      this.avatar,
      this.avatarCallback,
      this.textStyle,
      this.backgroundColor,
      this.avatarMargin,
      this.textPadding,
      this.avatarSize})
      : super(key: key);

  Widget _avatar(BuildContext context) {
    return GestureDetector(
        onTap: () => avatarCallback!(context),
        child: Container(
            width: avatarSize ?? 40,
            height: avatarSize ?? 40,
            margin: avatarMargin ?? const EdgeInsets.symmetric(horizontal: 5),
            child: ClipOval(child: avatar)));
  }

  Widget _text() {
    return Text(text!, style: textStyle ?? MyTheme.narmalStyle);
  }

  Widget _buildChild(List<Widget> children,
      [MainAxisAlignment? mainAxisAlignment]) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            children: children));
  }
}

class LeftBubble extends Bubble {
  final Function(BuildContext, String) textCallback;
  final double maxWidth;
  final TextStyle? dicStyle;
  const LeftBubble(
      {super.key,
      required String text,
      TextStyle? textStyle,
      required Color? backgroundColor,
      this.dicStyle,
      required Widget avatar,
      required Function(BuildContext) avatarCallback,
      required this.textCallback,
      required this.maxWidth})
      : super(
            text: text,
            avatar: avatar,
            backgroundColor: backgroundColor,
            textStyle: textStyle,
            avatarCallback: avatarCallback);

  Widget _textWidget(
      Function(BuildContext, String) callback, BuildContext context) {
    String dictionary = '';
    Widget textWithDic(List<String> textList) {
      TapGestureRecognizer tapRecognizer = TapGestureRecognizer()
        ..onTap = () => callback(context, dictionary);
      return Text.rich(TextSpan(children: [
        TextSpan(text: textList[0], style: textStyle ?? MyTheme.narmalStyle),
        TextSpan(
            text: textList[1],
            style: dicStyle ?? MyTheme.narmalStyle.copyWith(color: Colors.blue),
            recognizer: tapRecognizer),
        TextSpan(text: textList[2], style: textStyle ?? MyTheme.narmalStyle)
      ]));
    }

    Widget findDic() {
      final dictionaryList = context.read<DictionaryViewModel>().dictionaryList;
      final dictionaryMap = context.read<DictionaryViewModel>().dictionaryMap;
      for (String dic in dictionaryList) {
        int index = text!.indexOf(dic);
        if (index >= 0) {
          bool nowChapter =
              context.read<ChatViewModel>().chapter == dictionaryMap[dic][0];
          if (nowChapter) {
            final one = text!.substring(0, index);
            final two = text!.substring(index, index + dic.length);
            final three = text!.substring(index + dic.length, text!.length);
            dictionary = dic;
            return textWithDic([one, two, three]);
          }
        }
      }

      return Text(text!, style: textStyle ?? MyTheme.narmalStyle);
    }

    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: textPadding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: backgroundColor ?? const Color.fromRGBO(38, 38, 38, 1),
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: findDic());
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild([_avatar(context), _textWidget(textCallback, context)]);
  }
}

class ImageBubble extends Bubble {
  final String image;
  const ImageBubble(
      {super.key,
      required this.image,
      required Widget avatar,
      required Function(BuildContext) avatarCallback})
      : super(avatar: avatar, avatarCallback: avatarCallback);

  Widget _imageBody(BuildContext context) {
    final name = image.split('/').last.split('.').first;
    return GestureDetector(
        onTap: () => MyRoute.to(context, '/image_view', name),
        child: ClipRRect(
            borderRadius: BorderRadiusDirectional.circular(20),
            child: Image.asset(image, width: 195, height: 260)));
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild([_avatar(context), _imageBody(context)]);
  }
}

class MiddleBubble extends Bubble {
  const MiddleBubble(
      {super.key, required String text, required TextStyle textstyle})
      : super(text: text, textStyle: textstyle);
  @override
  Widget build(BuildContext context) {
    return _buildChild([_text()], MainAxisAlignment.center);
  }
}

class RightBubble extends Bubble {
  final double maxWidth;
  const RightBubble(
      {super.key,
      required Widget avatar,
      required Color backgroundColor,
      required Function(BuildContext) avatarCallback,
      required String text,
      required this.maxWidth})
      : super(
            avatar: avatar,
            avatarCallback: avatarCallback,
            backgroundColor: backgroundColor,
            text: text);

  Widget _textWidget() {
    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: textPadding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: backgroundColor ?? const Color.fromRGBO(38, 38, 38, 1),
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: _text());
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild(
        [_textWidget(), _avatar(context)], MainAxisAlignment.end);
  }
}

class VoiceBubble extends Bubble {
  final Function(BuildContext, String) voiceCallback;
  const VoiceBubble(
      {super.key,
      required String text,
      required Widget avatar,
      required Color backgroundColor,
      required Function(BuildContext) avatarCallback,
      required this.voiceCallback})
      : super(
            avatar: avatar,
            backgroundColor: backgroundColor,
            text: text,
            avatarCallback: avatarCallback);

  Widget _voice(BuildContext context) {
    double time = text!.length / 4;
    String showText = '${time.toStringAsFixed(1)}s';
    return GestureDetector(
        onTap: () {
          voiceCallback(context, text!);
        },
        child: Container(
            padding: textPadding ?? const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: backgroundColor ?? MyTheme.background,
                borderRadius: const BorderRadius.all(Radius.circular(7))),
            child: Row(children: [
              Text(showText, style: MyTheme.narmalStyle),
              const SizedBox(width: 5),
              Icon(Icons.record_voice_over,
                  color: Colors.white, size: MyTheme.narmalIconSize),
              const SizedBox(width: 5)
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild([_avatar(context), _voice(context)]);
  }
}

class TitleWidget extends StatefulWidget {
  const TitleWidget({super.key});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  Widget _buildChild() {
    final typing = context.select<ChatViewModel, bool>((model) => model.typing);
    final name = context.select<ChatViewModel, String>((model) => model.name);

    return GestureDetector(
        onDoubleTap: () {
          // storyPlayer(context);
        },
        child: CustomWidget(
            text: name,
            textList: const ['对方输入中.', '对方输入中..', '对方输入中...'],
            interval: const Duration(milliseconds: 500),
            switchValue: typing));
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild();
  }
}

class CustomWidget extends StatefulWidget {
  final String text;
  final List<String> textList;
  final Duration interval;
  final bool switchValue;

  const CustomWidget({
    Key? key,
    required this.text,
    required this.textList,
    required this.interval,
    required this.switchValue,
  }) : super(key: key);

  @override
  CustomWidgetState createState() => CustomWidgetState();
}

class CustomWidgetState extends State<CustomWidget> {
  Timer? timer;
  int currentIndex = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void wait() async {
    if (widget.switchValue) {
      await Future.delayed(widget.interval);
      setState(() {
        currentIndex = (currentIndex + 1) % widget.textList.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('构建标题');
    wait();
    return Text(
        widget.switchValue ? widget.textList[currentIndex] : widget.text,
        style: MyTheme.bigStyle);
  }
}

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Widget _bodyItemBuilder(List<Message> data, int index, BuildContext context) {
    Message item = data[index];
    double maxWidth = MediaQuery.of(context).size.width * 0.8;
    late Widget avatar;
    TextStyle textstyle = MyTheme.narmalStyle;
    late Color background;
    late Widget bubble;
    final nowMikoAvatar = context.watch<SettingViewModel>().nowMikoAvatar;

    if (item.type == MessageType.left ||
        item.type == MessageType.voice ||
        item.type == MessageType.image) {
      background = MyTheme.background;
      if (item.name == '未知用户') {
        avatar = Image.asset('assets/icon/未知用户.webp');
      } else {
        avatar = Image.asset('assets/icon/头像$nowMikoAvatar.webp');
      }
    }
    if (item.type == MessageType.left) {
      bubble = LeftBubble(
          avatar: avatar,
          backgroundColor: background,
          text: item.message,
          avatarCallback: (context) => item.avatarCallback(context),
          textCallback: (context, text) => item.textCallback(context, text),
          maxWidth: maxWidth);
    }
    if (item.type == MessageType.voice) {
      bubble = VoiceBubble(
          avatar: avatar,
          backgroundColor: background,
          text: item.message,
          avatarCallback: (context) => MyRoute.to(context, '/trend'),
          voiceCallback: (context, text) => item.voiceCallback(context, text));
    }
    if (item.type == MessageType.image) {
      bubble = ImageBubble(
          avatar: avatar,
          image: item.image,
          avatarCallback: (context) => item.avatarCallback(context));
    }
    if (item.type == MessageType.middle) {
      final text = item.message;
      late Color textColor;
      if (text == '对方已上线' || text == '切换对象中') {
        textColor = const Color.fromARGB(255, 0, 255, 8);
      }
      if (text == '对方已下线' || text == '信息未送达' || text == '对方账号不存在或已注销') {
        textColor = Colors.red;
      }
      // textColor = const Color.fromARGB(255, 206, 206, 206);
      final middlestyle = textstyle.copyWith(color: textColor);
      bubble = MiddleBubble(text: text, textstyle: middlestyle);
    }
    if (item.type == MessageType.right) {
      background = MyTheme.foreground62;
      final avatarUrl = context.watch<ChatViewModel>().avatarUrl;
      final narmalAvatar = Image.asset('assets/icon/未知用户.webp');
      avatar = avatarUrl.isEmpty
          ? narmalAvatar
          : CachedNetworkImage(
              imageUrl: avatarUrl,
              errorWidget: (context, url, error) => narmalAvatar);
      bubble = RightBubble(
          avatar: avatar,
          avatarCallback: item.avatarCallback,
          backgroundColor: background,
          text: item.message,
          maxWidth: maxWidth);
    }
    return bubble;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('构建身体');
    final message = context.watch<ChatViewModel>().message;
    final chatController = context.read<ChatViewModel>().chatController;
    return ListView.builder(
        controller: chatController,
        padding: const EdgeInsets.symmetric(vertical: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: message.length,
        itemBuilder: (ctx, index) => _bodyItemBuilder(message, index, ctx));
  }
}

class ChooseButton extends StatefulWidget {
  const ChooseButton({super.key});

  @override
  State<ChooseButton> createState() => _ChooseButtonState();
}

class _ChooseButtonState extends State<ChooseButton> {
  bool newUI = true;

  Widget button(String text, int jump, BuildContext context) {
    final model = context.read<ChatViewModel>();
    final buttonWidth = newUI
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 2 - 16;
    return TextButton(
        onPressed: () {
          final showChoose = context.read<ChatViewModel>().showChoose;
          if (!showChoose) return;
          final buttonMusic = context.read<SettingViewModel>().buttonMusic;
          if (buttonMusic) buttonPlayer.play();
          Message item = Message('', text, MessageType.right);
          model.addItem(item);
          model.changeShowChoose(false);
          model.changeJump(jump);
          storyPlayer(context);
        },
        child: Container(
            width: buttonWidth,
            height: newUI ? 35 : 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: newUI
                ? const BoxDecoration()
                : const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text(text, style: MyTheme.narmalStyle)));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('构建选项');

    final showChoose =
        context.select((ChatViewModel model) => model.showChoose);
    final leftChoose =
        context.select((ChatViewModel model) => model.leftChoose);
    final rightChoose =
        context.select((ChatViewModel model) => model.rightChoose);
    final leftJump = context.select((ChatViewModel model) => model.leftJump);
    final rightJump = context.select((ChatViewModel model) => model.rightJump);
    return !showChoose
        ? const SizedBox()
        : Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: newUI ? 0 : 5),
            color: newUI ? MyTheme.foreground62 : Colors.black,
            child: newUI
                ? Column(mainAxisSize: MainAxisSize.max, children: [
                    button(leftChoose, leftJump, context),
                    const SizedBox(height: 3),
                    Container(height: 1, color: Colors.grey),
                    const SizedBox(height: 2),
                    button(rightChoose, rightJump, context),
                    const SizedBox(height: 2)
                  ])
                : Row(mainAxisSize: MainAxisSize.max, children: [
                    button(leftChoose, leftJump, context),
                    button(rightChoose, rightJump, context)
                  ]));
  }
}

class ToLast extends StatefulWidget {
  const ToLast({super.key});

  @override
  State<ToLast> createState() => _ToLastState();
}

class _ToLastState extends State<ToLast> {
  RxBool show = false.obs;
  @override
  void initState() {
    super.initState();
    final chatScroller = context.read<ChatViewModel>().chatController;
    chatScroller.addListener(() {
      double now = chatScroller.position.pixels;
      double max = chatScroller.position.maxScrollExtent;
      if (now < max) {
        debugPrint('当前$now,最大$max');
        show.value = true;
      } else {
        debugPrint('当前$now,最大$max');
        show.value = false;
      }
    });
  }

  Widget _buildToLast() {
    final showChoose = context.watch<ChatViewModel>().showChoose;
    return Obx(() => !show.value
        ? const SizedBox()
        : Stack(children: [
            Positioned(
                right: 5,
                bottom: showChoose ? 120 : 20,
                child: GestureDetector(
                    onTap: () {
                      final chatScroller =
                          context.read<ChatViewModel>().chatController;
                      final max = chatScroller.position.maxScrollExtent;
                      chatScroller.animateTo(max,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceIn);
                    },
                    child: ClipOval(
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            color: MyTheme.foreground62,
                            child: const Icon(Icons.arrow_downward,
                                color: Colors.white)))))
          ]));
  }

  @override
  Widget build(BuildContext context) {
    return _buildToLast();
  }
}
