import 'dart:async';

import 'package:fanfan/components/chart/category_amounts_pie.dart';
import 'package:fanfan/components/transaction/thumbnail.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/amount_grouped_by_category.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/entities/transaction/paginated_transactions.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/utils/bottom_action_sheet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Statistics> {
  /// 周期索引
  int _durationIndex = 0;

  /// 交易列表
  List<Transaction> _transactions = [];

  /// 当前对应的页码
  int _page = 1;

  /// 总数
  int _total = 0;

  /// 分类下交易金额
  List<AmountGroupedByCategory> _amountsGroupedByCategory = [];

  /// 滚动控制器
  late final ScrollController _scrollController;

  /// 账本id
  late final int? _billingId;

  /// 周期列表
  late final List<_StatisticDuration> _durations;

  /// 获取交易列表的订阅器
  late final StreamController<int> transactionsQuerier;

  /// 初始化周期选项
  _initDurations() {
    final currentAt = DateTime.now();
    final currentYear = currentAt.year;
    final currentMonth = currentAt.month;
    final currentDay = currentAt.day;
    final currentWeekday = currentAt.weekday;
    final currentStartAt = DateTime(currentYear, currentMonth, currentDay);

    _durations = [
      _StatisticDuration(
        from: currentStartAt.subtract(Duration(days: currentWeekday - 1)),
        label: '当周',
      ),
      _StatisticDuration(
        from: DateTime(currentYear, currentMonth),
        label: '当月',
      ),
      _StatisticDuration(
        from: DateTime(currentYear),
        label: '当年',
      ),
      _StatisticDuration(
        from: currentStartAt.subtract(const Duration(days: 6)),
        label: '过去7天',
      ),
      _StatisticDuration(
        from: currentStartAt.subtract(const Duration(days: 29)),
        label: '过去30天',
      ),
    ];
  }

  /// 初始化页面的请求
  void _initStatistics() async {
    // 没有账本id，无法获取对应交易数据
    if (_billingId == null) {
      return;
    }

    // 请求页面数据
    final fetched = await queryTransactionAmountsGroupedByCategory(
      billingId: _billingId!,
      withTransaction: true,
      paginateBy: PaginateBy(
        page: _page,
        limit: 20,
      ),
    );

    final paginatedTransactions = fetched.item2!;

    // 请求成功，更新页面数据
    setState(() {
      _amountsGroupedByCategory = fetched.item1;
      _total = paginatedTransactions.total ?? 0;
      _transactions = [
        ..._transactions,
        ...paginatedTransactions.items,
      ];
    });
  }

  /// 初始化账本id
  _initBillingId() {
    _billingId = context.read<UserProfile>().whoAmI?.defaultBilling?.id;
  }

  @override
  initState() {
    super.initState();

    // 初始化周期选项
    _initDurations();
    // 初始化账本id
    _initBillingId();
    // 初始化统计数据
    _initStatistics();

    // 交易列表请求器
    transactionsQuerier = StreamController<int>()
      ..stream
          .takeWhile((_) => _billingId != null)
          .distinctUnique()
          .asyncMap<Tuple2<int, PaginatedTransactions>>((page) async {
        return Tuple2(
          page,
          await queryTransactions(
            billingId: _billingId!,
            paginateBy: PaginateBy(
              page: page,
              limit: 20,
            ),
          ),
        );
      }).listen((value) {
        setState(() {
          _total = value.item2.total ?? 0;
          _page = value.item1;
          _transactions = [
            ..._transactions,
            ...value.item2.items,
          ];
        });
      });

    // 监听滚动器，滚动到下方时，请求下一页数据
    _scrollController = ScrollController()
      ..addListener(() {
        // 没有更多数据时，不再请求
        // 仅当滚动到底部时，发起请求更多
        if (_transactions.length >= _total ||
            (_scrollController.position.pixels <
                _scrollController.position.maxScrollExtent - 50)) return;

        // 执行查询更多
        transactionsQuerier.add(_page + 1);
      });
  }

  /// 修改周期
  void _changeDuration() async {
    final selectedIndex = await showBottomActionSheet(context,
        actions: _durations.map(
          (e) {
            return e.label;
          },
        ).toList());

    // 用户取消选择
    if (selectedIndex == null) {
      return;
    }
    // 修改时间周期，获取新的周期内的数据
    setState(() {
      _durationIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationLayout(
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
                              onTap: _changeDuration,
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
                                      _durations
                                          .elementAt(_durationIndex)
                                          .label,
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
                        CategoryAmountsPie(
                          amounts: _amountsGroupedByCategory,
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticDuration {
  final DateTime from;
  final String label;

  _StatisticDuration({
    required this.from,
    required this.label,
  });
}
