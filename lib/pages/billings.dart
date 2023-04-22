import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Billings extends StatefulWidget {
  const Billings({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State {
  @override
  Widget build(Object context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.ticket_fill,
              color: Colors.blue,
              size: 36,
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                '我的账本',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
