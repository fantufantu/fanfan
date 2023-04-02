import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class HowToAuthorize extends StatelessWidget {
  const HowToAuthorize({super.key});

  @override
  Widget build(context) {
    return Scaffold(
        body: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Image.asset(
                  "images/unauthorized.png",
                  scale: 3,
                ),
                const Text(
                  'Let`s you in',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Column(
                children: const [
                  Divider(
                    color: Colors.black,
                    thickness: 30,
                  ),
                  Text(
                    '用账号密码方式',
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}
