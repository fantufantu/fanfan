import 'package:fanfan/service/entities/direction.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Thumbnail extends StatelessWidget {
  final Transaction transaction;

  const Thumbnail({
    super.key,
    required this.transaction,
  });

  bool get _isExpense {
    return transaction.category?.direction == Direction.Out;
  }

  Color get _primaryColor {
    return _isExpense ? Colors.red : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final iconCodePoint = transaction.category?.icon != null
        ? int.tryParse(transaction.category!.icon)
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconCodePoint != null
                  ? IconData(
                      iconCodePoint,
                      fontFamily: CupertinoIcons.iconFont,
                      fontPackage: CupertinoIcons.iconFontPackage,
                    )
                  : CupertinoIcons.money_yen_circle,
              size: 40,
              color: _primaryColor,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.category!.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd | HH:mm:ss')
                          .format(transaction.happenedAt!),
                      style: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.1,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '￥${transaction.amount.toString()}',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      CupertinoIcons.arrow_up_square,
                      color: _primaryColor,
                      size: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: Text(
                        _isExpense ? "Expense" : 'Income',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
