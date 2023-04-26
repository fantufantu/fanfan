import 'dart:math';
import 'package:fanfan/components/avatars.dart';
import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/service/entities/who_am_i.dart';
import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  static const List<String> _backgrounds = [
    'images/billing/background/blue.png',
    // 'images/billing/background/red.png',
  ];

  static final int _random = Random().nextInt(_backgrounds.length);

  static final _background = _backgrounds[_random];

  final Billing billing;

  Card({
    super.key,
    required this.billing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        boxShadow: kElevationToShadow[3],
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
                style: TextStyle(
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
            margin: EdgeInsets.only(top: 20),
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
                        strutStyle: const StrutStyle(forceStrutHeight: true),
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
                          billing.createdAt.timeZoneName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          strutStyle: const StrutStyle(forceStrutHeight: true),
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
