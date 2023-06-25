import 'package:fanfan/components/transaction/thumbnail.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/entities/transaction/paginated_transactions.dart';
import 'package:fanfan/service/factories/paginate_by.dart';
import 'package:fanfan/utils/confirm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

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

  /// 当前对应的页码
  int _page = 0;

  /// 总数
  int _total = 0;

  /// 滚动控制器
  late final ScrollController _scrollController;

  /// 获取交易列表的订阅器
  late final PublishSubject<int> transactionsQuerier;

  @override
  void initState() {
    super.initState();

    // 交易列表请求器
    transactionsQuerier = PublishSubject<int>()
      ..distinctUnique()
          .asyncMap<Tuple2<int, PaginatedTransactions>>((page) async {
            return Tuple2(
              page,
              await queryTransactions(
                billingId: widget.billingId,
                paginateBy: PaginateBy(
                  page: page,
                  limit: 20,
                ),
              ),
            );
          })
          .doOnError((p0, p1) {})
          .listen((value) {
            setState(() {
              _total = value.item2.total ?? 0;
              _page = value.item1;
              _transactions = [
                ..._transactions,
                ...value.item2.items,
              ];
            });
          })
      ..add(_page + 1);

    // 监听滚动器，滚动到下方时，请求下一页数据
    _scrollController = ScrollController()
      ..addListener(() {
        // 没有更多数据时，不再请求
        // 仅当滚动到底部时，发起请求更多
        if (_transactions.length >= _total ||
            (_scrollController.position.pixels <
                _scrollController.position.maxScrollExtent - 50)) return;

        transactionsQuerier.add(_page + 1);
      });
  }

  Future<bool> _confirmDismiss(int id) async {
    final action = await showConfirmDialog(
      context,
      title: const Text("用户确认"),
      content: const Text("确认删除当前交易吗？"),
    );

    // 用户取消操作，直接返回 false
    if (action == ConfirmAction.Cancel) {
      return false;
    }

    // 请求删除交易
    final isSucceed = await removeById(id);
    return isSucceed;
  }

  /// 跳转到明细
  void _navigateDetail(int id) async {
    context.pushNamed<Transaction>(
      NamedRoute.Transaction.name,
      pathParameters: {
        "id": id.toString(),
      },
      extra: {
        // 事件通知
        "listener": PublishSubject<Transaction>()
          ..listen((transaction) {
            setState(() {
              _transactions
                  .singleWhere((element) => element.id == transaction.id)
                ..amount = transaction.amount
                ..categoryId = transaction.categoryId
                ..category = transaction.category
                ..happenedAt = transaction.happenedAt
                ..remark = transaction.remark;
            });
          }),
      },
    );
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
                      (context, index) => Dismissible(
                        key: Key(_transactions.elementAt(index).id.toString()),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) =>
                            _confirmDismiss(_transactions.elementAt(index).id!),
                        onDismissed: (_) {
                          setState(() {
                            _transactions.removeAt(index);
                          });
                        },
                        background: Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 50, right: 50),
                                height: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "删除",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: InkWell(
                            onTap: () => _navigateDetail(
                                _transactions.elementAt(index).id!),
                            child: Thumbnail(
                              transaction: _transactions.elementAt(index),
                            ),
                          ),
                        ),
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
