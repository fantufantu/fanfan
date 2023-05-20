import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Transactions extends StatefulWidget {
  const Transactions({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    (() async {
      // 请求服务端获取交易列表
      final paginatedTransactions = await queryTransaction();
      setState(() {
        _transactions = paginatedTransactions.items;
      });
    })();

    super.initState();
  }

  @override
  Widget build(Object context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
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
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                    );
                  },
                  childCount: _transactions.length,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
