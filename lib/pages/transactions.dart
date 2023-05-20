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
  List<Transaction> _billings = [];

  @override
  void initState() {
    (() async {
      // 请求账本
      final paginatedBillings = await queryTransaction();

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
                    final billing = _billings[index];

                    return InkWell(
                      onTap: () {
                        context.go('/billing/${billing.id.toString()}');
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 12,
                        ),
                      ),
                    );
                  },
                  childCount: _billings.length,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}