// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
            Get.back();
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
    return const SizedBox();
    const tipList = ['', '', '', '', ''];

    return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                width: 1.sw / 1.5,
                color: Colors.black.withAlpha(150),
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(tipList[index], style: MyTheme.bigStyle)))));
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
