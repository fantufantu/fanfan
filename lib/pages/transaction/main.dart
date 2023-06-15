import 'package:fanfan/assets/category.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/pages/loading.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/service/entities/direction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fanfan/service/entities/transaction/main.dart' as entities;
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  final int id;

  const Transaction({
    super.key,
    required this.id,
  });

  @override
  State<Transaction> createState() => _State();
}

class _State extends State<Transaction> {
  /// 交易明细
  late entities.Transaction _transaction;

  /// 加载中
  bool isLoading = true;

  void _edit() {
    context.pushNamed(
      NamedRoute.EditableTransaction.name,
      pathParameters: {
        "id": widget.id.toString(),
      },
    );
  }

  @override
  void initState() {
    super.initState();

    (() async {
      final transaction = await queryTransactionById(widget.id);

      setState(() {
        _transaction = transaction;
        isLoading = false;
      });
    })();
  }

  /// item渲染
  Widget _buildDetailItem({
    required String label,
    String? value,
    Widget? valueWidget,
  }) {
    assert(value == null || valueWidget == null,
        'Cannot provide both a value and a valueWidget');
    assert(value != null || valueWidget != null,
        'Must provide a value or a valueWidget');

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: valueWidget != null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 32),
              child: valueWidget != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [valueWidget],
                    )
                  : Text(
                      value!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.end,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool get isExpense {
    return _transaction.category!.direction == Direction.Out;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Loading();
    }

    return PopLayout(
      title: const Text(
        '交易明细',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.grey.shade50,
      child: Container(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                boxShadow: kElevationToShadow[1],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      CATEGORY_ICONS[_transaction.category!.id],
                      color: Colors.white,
                    ),
                  ),
                  const Divider(height: 32),
                  _buildDetailItem(
                    label: '金额',
                    value: '￥${_transaction.amount}',
                  ),
                  _buildDetailItem(
                    label: '分类',
                    value: _transaction.category!.name,
                  ),
                  _buildDetailItem(
                    label: '备注',
                    value: _transaction.remark!,
                  ),
                  _buildDetailItem(
                    label: '消费人',
                    value: _transaction.createdBy!.nickname,
                  ),
                  _buildDetailItem(
                    label: '交易日期',
                    value: DateFormat('yyyy-MM-dd')
                        .format(_transaction.happenedAt!),
                  ),
                  _buildDetailItem(
                    label: '交易ID',
                    value: _transaction.id.toString(),
                  ),
                  _buildDetailItem(
                    label: '交易方向',
                    valueWidget: Container(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: isExpense ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isExpense ? '支出' : '收入',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _edit,
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
                ),
                child: const Text(
                  "修改交易",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
