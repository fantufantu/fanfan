import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
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

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

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

    // 初始化请求列表数据，请求第一页数据
    _fetchMore();

    // 监听滚动器，滚动到下方时，请求下一页数据
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 30) {
        _fetchMore();
      }
    });
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
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final transaction = _transactions.elementAt(index);

                          return Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: kElevationToShadow[1],
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
                                          Text(
                                            DateFormat('yyyy-MM-dd | HH:mm:ss')
                                                .format(
                                                    transaction.happenedAt!),
                                            style: const TextStyle(
                                              letterSpacing: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}
