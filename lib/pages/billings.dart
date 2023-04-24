import 'package:fanfan/service/api/billing.dart';
import 'package:fanfan/service/entities/billing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Billings extends StatefulWidget {
  const Billings({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State {
  List<Billing> _billings = [];

  @override
  void initState() {
    (() async {
      // 请求账本
      final paginatedBillings = await queryBillings();

      setState(() {
        // 账本列表
        _billings = paginatedBillings.items;
      });
    })();

    super.initState();
  }

  @override
  Widget build(Object context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.tickets_fill,
              color: Colors.deepOrange.shade500,
              size: 36,
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: const Text(
                '我的账本',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        ...(_billings.map((e) {
          return Container(
            child: Text((e.id).toString()),
          );
        }))
      ],
    );
  }
}
