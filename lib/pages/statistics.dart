import 'package:fanfan/components/chart/expense_ratio.dart';
import 'package:fanfan/components/transaction/thumbnail.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  late int? _billingId;

  final _supportDurations = const {
    7: "This week",
    30: "This month",
    365: "This year",
  };

  /// 当前对应的页码
  int _page = 0;

  /// 总数
  int _total = 0;

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  _fetchMore() async {
    // 没有账本id，无法获取对应交易数据
    if (_billingId == null) {
      return;
    }

    // 需要查询的页码
    final page = _page + 1;
    // 请求服务端获取交易列表
    final paginatedTransactions = await queryTransactions(
        billingId: _billingId!,
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
  initState() {
    super.initState();

    // 默认账本id
    _billingId = context.read<UserProfile>().whoAmI?.defaultBilling?.id;
    // 按着默认时间间隔请求交易列表
    _fetchMore();
    // 监听滚动器，滚动到下方时，请求下一页数据
    _scrollController.addListener(() {
      // 没有更多数据时，不再请求
      if (_transactions.length >= _total) {
        return;
      }
      // 仅当滚动到底部时，发起请求更多
      if (_scrollController.position.pixels <
          _scrollController.position.maxScrollExtent - 30) {
        return;
      }
      // 执行查询更多
      _fetchMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationLayout(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: Container(
          margin: const EdgeInsets.only(left: 4),
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
      child: Container(
        color: Colors.grey.shade50,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Statistics Grapgh",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(item.value),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 6, bottom: 6),
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
                                    Text(
                                      _supportDurations[_duration]!,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      child: const Icon(
                                        CupertinoIcons.chevron_down,
                                        color: Colors.blue,
                                        size: 14,
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
                              const Text(
                                "Transactions",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    context.pushNamed(
                                      NamedRoute.Transactions.name,
                                      pathParameters: {
                                        "billingId": _billingId.toString(),
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "See All",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  margin: EdgeInsets.only(
                      top: 20,
                      bottom: (index == _transactions.length - 1 ? 20 : 0)),
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
