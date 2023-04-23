import 'package:flutter/material.dart';

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _State();
}

class _State extends State<Selector> {
  /// 预设的背景图片
  static const _presetBackgrounds = [
    'images/billing/background/blue.png',
    'images/billing/background/red.png'
  ];

  /// 滚动控制器
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: List.from(
        _presetBackgrounds.map((assetName) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(assetName))),
            )),
      ),
    );
  }
}
