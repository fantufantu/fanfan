import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Switch extends StatefulWidget {
  Switch({
    super.key,
    required this.children,
    this.value = 0,
    this.primaryColor = Colors.blue,
    required this.onChanged,
  }) : assert([0, 1].contains(value));

  final double _height = 60;

  final Tuple2<String, String> children;
  final int value;
  final Color primaryColor;
  final ValueChanged<int> onChanged;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Switch> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        value: widget.value.toDouble());
    animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return LayoutBuilder(builder: (context, constraints) {
            // 获取父级widget最大宽度
            final width = constraints.widthConstraints().biggest.width;
            final half = width / 2;
            final radius = widget._height / 2;

            return Stack(
              children: [
                Row(
                  children: [
                    ...(widget.children
                            .toList()
                            .map((e) => e.toString())
                            .toList())
                        .asMap()
                        .entries
                        .map((entry) {
                      final isReverse = entry.key == 0;
                      final BorderRadiusGeometry borderRadius =
                          BorderRadius.only(
                        topLeft: Radius.circular(isReverse ? radius : 0),
                        bottomLeft: Radius.circular(isReverse ? radius : 0),
                        topRight: Radius.circular(isReverse ? 0 : radius),
                        bottomRight: Radius.circular(isReverse ? 0 : radius),
                      );

                      onTap() {
                        isReverse ? controller.reverse() : controller.forward();
                        widget.onChanged(entry.key);
                      }

                      return InkWell(
                        onTap: onTap,
                        child: Container(
                          width: half,
                          height: widget._height,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: widget.primaryColor,
                              width: 4,
                            ),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: widget.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()..rotateY(animation.value * pi),
                  child: Container(
                    width: width / 2,
                    height: widget._height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        bottomLeft: Radius.circular(radius),
                      ),
                    ),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(animation.value * pi),
                      child: Text(
                        animation.value > 0.5
                            ? widget.children.item2
                            : widget.children.item1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }
}
