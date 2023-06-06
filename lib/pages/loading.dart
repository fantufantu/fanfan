import 'dart:math';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({
    super.key,
  });

  @override
  State<Loading> createState() => _State();
}

class _State extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  Loading() {}

  @override
  initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    animation = Tween(begin: 0.0, end: 100.0).animate(controller);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: animation,
          builder: (ctx, _) {
            return Center(
              child: CustomPaint(
                painter: CirclePainter(value: animation.value),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  double value;

  CirclePainter({
    required this.value,
  });

  final List<Paint> _paints = [
    Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round,
    Paint()
      ..color = Colors.orange
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round,
    Paint()
      ..color = Colors.blue
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round,
    Paint()
      ..color = Colors.pink
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // 圈1
    paintCircle1(canvas, value);
    // 圈2
    paintCircle2(canvas, value);
    // 圈3
    paintCircle3(canvas, value);
    // 圈4
    paintCircle4(canvas, value);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// 画第一个圈
  void paintCircle1(Canvas canvas, double value) {
    final rect = _rects.elementAt(0);
    final paint = _paints.elementAt(0);

    // 开始状态，保持圆点
    // 结束状态，保持圆点
    if (value <= 4 || value >= 90) {
      return canvas.drawCircle(const Offset(-90, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 12) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 4), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 32) {
      return canvas.drawArc(
          rect, (value - 12) / 20 * 5 / 6 * pi + pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 40) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 40), false, paint);
    }

    // 保持圆点一段时间
    if (value <= 54) {
      return canvas.drawCircle(const Offset(90, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 62) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 54), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 82) {
      return canvas.drawArc(
          rect, (value - 62) / 20 * 5 / 6 * pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 90) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 90), false, paint);
    }
  }

  /// 画第二个圈
  void paintCircle2(Canvas canvas, double value) {
    final rect = _rects.elementAt(1);
    final paint = _paints.elementAt(1);

    // 开始状态，保持圆点
    // 结束状态，保持圆点
    if (value <= 12 || value >= 98) {
      return canvas.drawCircle(const Offset(-30, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 20) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 12), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 40) {
      return canvas.drawArc(
          rect, (value - 20) / 20 * 5 / 6 * pi + pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 48) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 48), false, paint);
    }

    // 保持圆点一段时间
    if (value <= 62) {
      return canvas.drawCircle(const Offset(30, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 70) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 62), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 90) {
      return canvas.drawArc(
          rect, (value - 70) / 20 * 5 / 6 * pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 98) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 98), false, paint);
    }
  }

  /// 画第三个圈
  void paintCircle3(Canvas canvas, double value) {
    final rect = _rects.elementAt(2);
    final paint = _paints.elementAt(2);

    // 开始状态，保持圆点
    // 结束状态，保持圆点
    if (value == 0 || value >= 94) {
      return canvas.drawCircle(const Offset(30, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 8) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * value, false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 28) {
      return canvas.drawArc(
          rect, (value - 8) / 20 * 5 / 6 * pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 36) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 36), false, paint);
    }

    // 保持圆点一段时间
    if (value <= 58) {
      return canvas.drawCircle(const Offset(-90, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 66) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 58), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 86) {
      return canvas.drawArc(
          rect, (value - 66) / 20 * 5 / 6 * pi + pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 94) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 94), false, paint);
    }
  }

  /// 画第四个圈
  void paintCircle4(Canvas canvas, double value) {
    final rect = _rects.elementAt(3);
    final paint = _paints.elementAt(3);

    // 开始状态，保持圆点
    // 结束状态，保持圆点
    if (value <= 8 || value >= 86) {
      return canvas.drawCircle(const Offset(90, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 16) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 8), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 36) {
      return canvas.drawArc(
          rect, (value - 16) / 20 * 5 / 6 * pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 44) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 44), false, paint);
    }

    // 保持圆点一段时间
    if (value <= 50) {
      return canvas.drawCircle(const Offset(-30, 0), 0, paint);
    }

    // 尝试从圆点扩散为圆弧
    if (value <= 58) {
      return canvas.drawArc(rect, pi, pi / 6 / 8 * (value - 50), false, paint);
    }

    // 扩散完成后，开始绕圆心旋转
    if (value <= 78) {
      return canvas.drawArc(
          rect, (value - 58) / 20 * 5 / 6 * pi + pi, pi / 6, false, paint);
    }

    //  抵达180度后，圆弧收缩为圆点
    if (value < 86) {
      return canvas.drawArc(rect, 0, pi / 6 / 8 * (value - 86), false, paint);
    }
  }

  final List<Rect> _rects = [
    Rect.fromCircle(
      center: Offset.zero,
      radius: 90,
    ),
    Rect.fromCircle(
      center: Offset.zero,
      radius: 30,
    ),
    Rect.fromCircle(
      center: const Offset(-30, 0),
      radius: 60,
    ),
    Rect.fromCircle(
      center: const Offset(30, 0),
      radius: 60,
    ),
  ];
}
