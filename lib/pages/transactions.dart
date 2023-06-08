import 'package:fanfan/components/transaction/thumbnail.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  final int billingId;

  const Transactions({
    super.key,
    required this.billingId,
  });

  @override
  State<Transactions> createState() => _State();
}

class _State extends State<Transactions> {
  List<Transaction> _transactions = [];

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 当前对应的页码
  int _page = 0;

  /// 总数
  int _total = 0;

  _fetchMore() async {
    // 需要查询的页码
    final page = _page + 1;

    // 请求服务端获取交易列表
    final paginatedTransactions = await queryTransactions(
        billingId: widget.billingId,
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
      // 没有更多数据时，不再请求
      if (_transactions.length >= _total) {
        return;
      }

      // 仅当滚动到底部时，发起请求更多
      if (_scrollController.position.pixels <
          _scrollController.position.maxScrollExtent - 30) {
        return;
      }

      _fetchMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      backgroundColor: Colors.grey.shade50,
      title: const Text(
        'In & Out Payment',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          letterSpacing: 2,
          color: Colors.black,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Thumbnail(
                            transaction: _transactions.elementAt(index)),
                      ),
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
