import 'package:flutter/material.dart';
import 'package:miko/page/chat/chat_view_model.dart';
import 'package:miko/page/chat/controller.dart';
import 'package:miko/utils/routes.dart';
import 'package:provider/provider.dart';

import 'theme/color.dart';

Widget cilpWidget(
    {required double width,
    required double height,
    required double yOffset,
    required Widget child}) {
  return SizedBox(
      width: double.infinity,
      child: FittedBox(
          child: SizedBox(
              width: width,
              height: height,
              child:
                  Stack(children: [Positioned(top: yOffset, child: child)]))));
}

///回到某天弹窗
void jumpDayDialog(BuildContext context) {
  const Map<String, List<int>> days = {
    '第一章': [0, 467, 1132],
    '番外一': [0],
    '第二章': [0, 671, 1529],
    '番外二': [0],
    '第三章': [0, 1299, 2677],
    '番外三': [0, 272, 482],
    '第四章': [0, 712, 1411, 2013],
    '第五章': [0, 469, 840],
    '第六章': [0, 888, 1406, 2203]
  };
  TextButton jumpDayButton(BuildContext context, int line, int day) {
    return TextButton(
        onPressed: () {
          final model = context.read<ChatViewModel>();
          model.clearMessage();
          model.changeLine(line);
          model.changeJump(0);
          model.changeLeftChoose('');
          model.changeRightChoose('');
          model.changeShowChoose(false);
          model.changeStartTime(0);
          storyPlayer(context);
          MyRoute.back(context);
        },
        child: Container(
            width: 250,
            height: 55,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: MyTheme.foreground62,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            child: Center(child: Text('第$day天', style: MyTheme.bigStyle))));
  }

  Widget jumpDayBody(BuildContext context, List<int> day) {
    return Column(
        children: day
            .asMap()
            .entries
            .map((entry) => jumpDayButton(context, entry.value, entry.key + 1))
            .toList());
  }

  showDialog(
      context: context,
      builder: (context) {
        final nowChapter = context.read<ChatViewModel>().chapter;
        return SimpleDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('天数跳转', style: MyTheme.bigStyle)]),
            backgroundColor: MyTheme.background51,
            children: [jumpDayBody(context, days[nowChapter]!)]);
      });
}

Widget buildDefaultItem(
    {required IconData leading,
    required String title,
    String? subTitle,
    Widget? button,
    Function? onTap}) {
  return GestureDetector(
      onTap: () => onTap?.call(),
      child: ListTile(
          leading:
              Icon(leading, color: Colors.grey, size: MyTheme.narmalIconSize),
          title: Text(title, style: MyTheme.bigStyle),
          subtitle: subTitle == null
              ? null
              : Text(subTitle,
                  style: MyTheme.narmalStyle.copyWith(fontSize: 12)),
          trailing: button ??
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.grey, size: 20)));
}

Widget buildCard(
    {required List<Widget> children,
    bool padding = false,
    bool addLine = true}) {
  Widget line = Container(
      height: 1,
      color: const Color.fromARGB(255, 57, 57, 57),
      margin: const EdgeInsets.symmetric(horizontal: 30));
  if (children.length >= 2) {
    for (int index = 0; index < children.length; index++) {
      int result = index % 2;
      if (result == 1) {
        if (addLine) children.insert(index, line);
      }
    }
  }
  return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          color: MyTheme.foreground,
          padding: EdgeInsets.all(padding ? 10 : 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children)));
}
