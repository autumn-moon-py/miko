import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:miko/page/dictionary/dictionary_view_model.dart';
import 'package:miko/theme/color.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:miko/widget.dart';
import 'package:provider/provider.dart';

import '../image/image_view_model.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = '';
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    version = await Utils.getVersion();
    setState(() {});
  }

  Widget _aboutWidget({required Widget body, required Widget background}) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: MyTheme.foreground,
            title: Text('关于异次元通讯', style: MyTheme.bigStyle)),
        body: Stack(children: [background, body]));
  }

  Widget _buildBackground() {
    return Container(color: MyTheme.background);
  }

  void caidna() {
    context.read<ImageViewModel>().lockAllImage();
    context.read<DictionaryViewModel>().lockAllDic();
    EasyLoading.showSuccess('你已触发彩蛋, 本次启动解锁全部词典和图鉴，下次进入重置为原解锁进度');
  }

  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(children: [
          const SizedBox(height: 10),
          GestureDetector(
            onDoubleTap: () {
              // caidna();
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/icon/icon.webp', width: 70)),
          ),
          const SizedBox(height: 5),
          GestureDetector(
              onDoubleTap: () {
                // caidna();
              },
              child: Text(version,
                  style: MyTheme.bigStyle.copyWith(color: Colors.grey))),
          const SizedBox(height: 5),
          GestureDetector(
              onDoubleTap: () {
                caidna();
              },
              child: Text('秋月',
                  style: MyTheme.narmalStyle.copyWith(color: Colors.grey))),
          const SizedBox(height: 10),
          buildCard(children: [
            buildDefaultItem(
                leading: Icons.my_library_books_sharp,
                title: '官网',
                onTap: () => Utils.openWebSite('https://app.subrecovery.top')),
            buildDefaultItem(
                leading: Icons.my_library_books_sharp,
                title: 'TapTap',
                onTap: () =>
                    Utils.openWebSite('https://www.taptap.cn/app/378027')),
            buildDefaultItem(
                leading: Icons.my_library_books_sharp,
                title: '好游快爆',
                onTap: () =>
                    Utils.openWebSite('https://www.3839.com/a/156008.htm')),
            buildDefaultItem(
                leading: Icons.group,
                title: 'Q群',
                onTap: () => Utils.openWebSite(
                    'http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=HwflPNcfx2rhVytyseGN3H0mFco-c-dk&authKey=sBbYcY9JUM5ngMdwEVm9vnrEj%2FfCmqfzBfo4W%2B4LbgaWH6jLiezKB2uvo3J%2FJpha&noverify=0&group_code=673105016')),
            buildDefaultItem(
                leading: Icons.emoji_food_beverage_rounded,
                title: '投喂',
                onTap: () =>
                    Utils.openWebSite('https://afdian.net/a/subrecovery'))
          ])
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return _aboutWidget(background: _buildBackground(), body: _buildBody());
  }
}
