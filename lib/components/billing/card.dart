import 'dart:math';
import 'package:fanfan/components/avatars.dart';
import 'package:fanfan/service/entities/billing/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Card extends StatelessWidget {
  /// 背景图
  static const List<String> _backgrounds = [
    'images/billing/background/blue.png',
    // 'images/billing/background/red.png',
  ];

  /// 背景图选中随机值
  static final int _random = Random().nextInt(_backgrounds.length);

  /// 随机的背景图
  static final _background = _backgrounds[_random];

  /// 账本信息
  final Billing billing;

  /// 阴影值
  final int? elevation;

  const Card({
    super.key,
    required this.billing,
    this.elevation,
  });

  int get _elevation {
    if (elevation == null) return 3;
    return elevation!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        boxShadow: kElevationToShadow[_elevation],
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        image: DecorationImage(
          image: AssetImage(_background),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                billing.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Avatars(
                avatars: ['', '', '', '', ''],
                limit: 3,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '持有人',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(
                        billing.createdBy.nickname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '创建于',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat.yMd().format(billing.createdAt),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
