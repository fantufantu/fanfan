import 'package:fanfan/components/chart/expense_ratio.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ExpenseRatio();
                },
                childCount: 1,
              ),
            ),
          ],
        )
      ],
    );
  }
}
