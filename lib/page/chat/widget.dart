import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:miko/page/dictionary/dictionary_view_model.dart';
import 'package:miko/page/chat/controller.dart';
import 'package:miko/page/setting/setting_view_model.dart';
import 'package:miko/theme/color.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:miko/utils/routes.dart';
import 'package:provider/provider.dart';

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

class Bubble extends StatelessWidget {
  final String text;
  final MessageType type;
  final Widget? avatar;
  final Widget? image;
  final Function(BuildContext) avatarCallback;
  final Function(BuildContext, String) textCallback;
  final Function(BuildContext, String)? voiceCallback;
  final TextStyle? textStyle;
  final TextStyle? dicStyle;
  final Color? backgroundColor;
  final EdgeInsets? avatarMargin;
  final EdgeInsets? textMargin;
  final EdgeInsets? textPadding;
  final double maxWidth;
  final double? avatarSize;
  final Color? textColor;
  final bool? newUI;
  final bool bubbleAnimation;
  const Bubble(
      {super.key,
      required this.text,
      required this.type,
      this.avatar,
      required this.avatarCallback,
      required this.textCallback,
      this.textStyle,
      this.dicStyle,
      this.backgroundColor,
      this.avatarMargin,
      this.textMargin,
      this.textPadding,
      required this.maxWidth,
      this.image,
      this.avatarSize,
      this.textColor,
      this.newUI = true,
      required this.bubbleAnimation,
      this.voiceCallback});
  Widget _avatar(BuildContext context) {
    return GestureDetector(
        onTap: () => avatarCallback(context),
        child: Container(
            width: avatarSize ?? 40,
            height: avatarSize ?? 40,
            margin: avatarMargin ?? const EdgeInsets.symmetric(horizontal: 5),
            child: ClipOval(child: avatar)));
  }

  Widget _text(Function(BuildContext, String) callback,
      [BuildContext? context]) {
    String dictionary = '';
    TextStyle style =
        MyTheme.narmalStyle.copyWith(color: textColor ?? Colors.white);
    Widget textWithDic(List<String> textList) {
      TapGestureRecognizer tapRecognizer = TapGestureRecognizer()
        ..onTap = () => callback(context!, dictionary);
      return Text.rich(TextSpan(children: [
        TextSpan(text: textList[0], style: textStyle ?? style),
        TextSpan(
            text: textList[1],
            style: dicStyle ?? style.copyWith(color: Colors.blue),
            recognizer: tapRecognizer),
        TextSpan(text: textList[2], style: textStyle ?? style)
      ]));
    }

    Widget findDic() {
      if (type == MessageType.left) {
        final dictionaryList =
            context!.read<DictionaryViewModel>().dictionaryList;
        final dictionaryMap = context.read<DictionaryViewModel>().dictionaryMap;
        for (String dic in dictionaryList) {
          int index = text.indexOf(dic);
          if (index >= 0) {
            bool nowChapter =
                context.read<ChatViewModel>().chapter == dictionaryMap[dic][0];
            if (nowChapter) {
              final one = text.substring(0, index);
              final two = text.substring(index, index + dic.length);
              final three = text.substring(index + dic.length, text.length);
              dictionary = dic;
              return textWithDic([one, two, three]);
            }
          }
        }
      }
      return Text(text, style: textStyle ?? style);
    }

    return Container(
        margin: textMargin ?? const EdgeInsets.only(top: 0),
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: textPadding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: backgroundColor ?? const Color.fromRGBO(38, 38, 38, 1),
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: findDic());
  }

  Widget _voice(Function(BuildContext, String) callback, BuildContext context) {
    double time = text.length / 4;
    String showText = '${time.toStringAsFixed(1)}s';
    return GestureDetector(
        onTap: () {
          callback.call(context, text);
        },
        child: Container(
            margin: textMargin ?? const EdgeInsets.only(top: 0),
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

  MainAxisAlignment _messageType(MessageType type) {
    if (type == MessageType.left || type == MessageType.image) {
      return MainAxisAlignment.start;
    }
    if (type == MessageType.middle) return MainAxisAlignment.center;
    if (type == MessageType.right) return MainAxisAlignment.end;
    return MainAxisAlignment.start;
  }

  List<Widget> _children(MessageType type, BuildContext context) {
    if (type == MessageType.left) {
      return [_avatar(context), _text(textCallback, context)];
    }
    if (type == MessageType.middle) {
      return [_text(textCallback)];
    }
    if (type == MessageType.image) {
      return [_avatar(context), image!];
    }
    if (type == MessageType.right) {
      return [_text(textCallback), _avatar(context)];
    }
    if (type == MessageType.voice) {
      return [_avatar(context), _voice(voiceCallback!, context)];
    }
    return [];
  }

  Widget _buildChild({required Widget child}) {
    if (bubbleAnimation) {
      if (type == MessageType.left) {
        return FadeInLeft(
            duration: const Duration(milliseconds: 300), child: child);
      }
      if (type == MessageType.right) {
        return FadeInRight(
            duration: const Duration(milliseconds: 300), child: child);
      }
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: _messageType(type),
                children: _children(type, context))));
  }
}

class TitleWidget extends StatefulWidget {
  const TitleWidget({super.key});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('构建标题');
    final typing = context.select((ChatViewModel model) => model.typing);
    final name = context.select((ChatViewModel model) => model.name);

    return GestureDetector(
        onTap: () {
          EasyLoading.showToast('开始播放');
          storyPlayer(context);
        },
        child: Text(typing ? '对方输入中...' : name, style: MyTheme.bigStyle));
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
    double maxWidth = MediaQuery.of(context).size.width * 0.73;
    Widget? avatar;
    Color? textColor;
    Color? background;
    Widget? image;
    bool newUI = true;
    final bubbleAnimation = context.watch<SettingViewModel>().bubbleAnimation;
    final nowMikoAvatar = context.watch<SettingViewModel>().nowMikoAvatar;
    if (item.type == MessageType.left) {
      background = MyTheme.background;
      if (item.name == '未知用户') {
        avatar = Image.asset('assets/icon/未知用户.webp');
      } else {
        avatar = Image.asset('assets/icon/头像$nowMikoAvatar.webp');
      }
    }
    if (item.type == MessageType.voice) {
      avatar = Image.asset('assets/icon/头像$nowMikoAvatar.webp');
    }
    if (item.type == MessageType.middle) {
      final text = item.message;
      if (text == '对方已上线' || text == '切换对象中') {
        textColor = const Color.fromARGB(255, 0, 255, 8);
      }
      if (text == '对方已下线' || text == '信息未送达' || text == '对方账号不存在或已注销') {
        textColor = Colors.red;
      }
      if (newUI) {
        background = Colors.transparent;
        textColor = const Color.fromARGB(255, 206, 206, 206);
      }
    }
    if (item.type == MessageType.right) {
      background = MyTheme.foreground62;
      final avatarUrl = context.watch<ChatViewModel>().avatarUrl;
      avatar = avatarUrl.isEmpty
          ? Image.asset('assets/icon/未知用户.webp')
          : CachedNetworkImage(
              imageUrl: avatarUrl,
              errorWidget: (context, url, error) =>
                  Image.asset('assets/icon/未知用户.webp'));
    }
    if (item.type == MessageType.image) {
      image = GestureDetector(
          onTap: () => MyRoute.to(context, '/image_view', item.image),
          child: ClipRRect(
              borderRadius: BorderRadiusDirectional.circular(20),
              child: Image.asset(item.image, width: 195, height: 260)));
    }
    return Bubble(
        text: item.message,
        type: item.type,
        avatarCallback: item.avatarCallback,
        backgroundColor: background,
        textCallback: item.textCallback,
        voiceCallback: item.voiceCallback,
        avatar: avatar,
        image: image,
        textColor: textColor,
        bubbleAnimation: bubbleAnimation,
        maxWidth: maxWidth);
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
                    Container(height: 1, color: Colors.grey),
                    button(rightChoose, rightJump, context)
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
