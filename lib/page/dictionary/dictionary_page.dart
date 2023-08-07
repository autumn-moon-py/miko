import 'package:flutter/material.dart';

import '../../theme/color.dart';
import 'widget.dart';

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({super.key});
  Widget _dictionaryWidget({required Widget body, required Widget background}) {
    return Stack(children: [background, body]);
  }

  Widget _buildBody(BuildContext context) {
    return const DictionaryBody();
  }

  Widget _buildBackground(BuildContext context) {
    return Container(color: MyTheme.background);
    // final screenSize = MediaQuery.of(context).size;
    // return Image.asset('assets/images/菜单背景.webp',
    //     width: screenSize.width, height: screenSize.height, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('词典', style: MyTheme.bigStyle),
            backgroundColor: MyTheme.background51),
        // floatingActionButton: FloatingActionButton(onPressed: () {}),
        body: _dictionaryWidget(
            body: _buildBody(context), background: _buildBackground(context)));
  }
}
