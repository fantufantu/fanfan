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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(transaction.id.toString()),
                    Text(
                      DateFormat('yyyy-MM-dd | HH:mm:ss')
                          .format(transaction.happenedAt!),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      margin: const EdgeInsets.only(left: 4),
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
  }
}
