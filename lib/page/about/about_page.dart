import 'package:flutter/material.dart';
import 'package:miko/theme/color.dart';
import 'package:miko/utils/app_utils.dart';
import 'package:miko/widget.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = '1.0.0';
  @override
  void initState() {
    super.initState();
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
            title: const Text('关于异次元通讯')),
        body: Stack(children: [background, body]));
  }

  Widget _buildBackground() {
    return Container(color: MyTheme.background);
  }

  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(children: [
          const SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/icon/icon.webp', width: 70)),
          const SizedBox(height: 5),
          Text(version,
              style: const TextStyle(color: Colors.grey, fontSize: 20)),
          const SizedBox(height: 5),
          const Text('秋月', style: TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 10),
          buildCard(children: [
            buildDefaultItem(
                leading: Icons.my_library_books_sharp,
                title: '官网',
                onTap: () => Utils.openWebSite('https://www.subrecovery.top')),
            buildDefaultItem(
                leading: Icons.upgrade,
                title: '更新',
                onTap: () => Utils.openWebSite('https://app.subrecovery.top')),
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
