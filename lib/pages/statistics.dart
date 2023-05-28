import 'package:fanfan/components/chart/expense_ratio.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Statistics> {
  int _duration = 7;

  final _supportDurations = const {
    7: "This week",
    30: "This month",
    365: "This year",
  };

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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_supportDurations[_duration]!),
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    child: Icon(
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
                      ExpenseRatio(),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Transactions"),
                            TextButton(onPressed: () {}, child: Text("See All"))
                          ],
                        ),
                      )
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
