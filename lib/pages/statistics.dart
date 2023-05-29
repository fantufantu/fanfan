import 'package:fanfan/components/chart/expense_ratio.dart';
import 'package:fanfan/components/transaction/thumbnail.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Statistics> {
  int _duration = 7;
  List<Transaction> _transactions = [];

  final _supportDurations = const {
    7: "This week",
    30: "This month",
    365: "This year",
  };

  /// 当前对应的页码
  int _page = 0;

  /// 总数
  int _total = 0;

  _fetchMore() async {
    // 条目数 >= 总数，不再请求
    if (_transactions.length >= _total) {
      return;
    }
    // 需要查询的页码
    final page = _page + 1;

    // 请求服务端获取交易列表
    final paginatedTransactions = await queryTransactions(
        billingId: 2,
        direction: Direction.Out.name,
        paginateBy: PaginateBy(
          page: page,
          pageSize: 20,
        ));

    // 请求成功，更新页面数据
    setState(() {
      _total = paginatedTransactions.total ?? 0;
      _page = page;
      _transactions = [
        ..._transactions,
        ...paginatedTransactions.items,
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    // 按着默认时间间隔请求交易列表
    _fetchMore();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationLayout(
      appBar: AppBar(
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.only(left: 24),
          child: const Text(
            "Statistics",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
        ),
        centerTitle: false,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Statistics Grapgh"),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return CupertinoActionSheet(
                                    actions: _supportDurations.entries
                                        .map<CupertinoActionSheetAction>(
                                            (item) =>
                                                CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      setState(() {
                                                        _duration = item.key;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(item.value)))
                                        .toList(),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_supportDurations[_duration]!),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: const Icon(
                                      CupertinoIcons.chevron_down,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const ExpenseRatio(),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Transactions"),
                            TextButton(
                                onPressed: () {
                                  context
                                      .pushNamed(NamedRoute.Transactions.name);
                                },
                                child: const Text("See All"))
                          ],
                        ),
                      )
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Thumbnail(transaction: _transactions.elementAt(index)),
                ),
                childCount: _transactions.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
