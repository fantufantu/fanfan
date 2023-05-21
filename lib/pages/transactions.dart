import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
      final paginatedTransactions = await queryTransaction(
        billingId: 2,
        direction: Direction.Out.name,
      );
      setState(() {
        _transactions = paginatedTransactions.items;
      });
    })();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              context.canPop() ? context.pop() : context.go('/');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        title: const Text(
          'In & Out Payment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 2,
            color: Colors.black,
          ),
          // strutStyle: const StrutStyle(forceStrutHeight: true),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final transaction = _transactions.elementAt(index);

                        print(transaction.direction);

                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.alarm),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(transaction.id.toString()),
                                        Text(DateFormat.yMd()
                                            .format(transaction.happenedAt!))
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('￥${transaction.amount.toString()}'),
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.arrow_up_square,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 4),
                                          child: const Text("Expense"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
        ),
      ),
    );
  }
}
