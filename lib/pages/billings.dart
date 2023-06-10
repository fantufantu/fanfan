import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/billing.dart';
import 'package:fanfan/service/entities/billing/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fanfan/components/billing/card.dart' as components show Card;
import 'package:go_router/go_router.dart';

class Billings extends StatefulWidget {
  const Billings({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State {
  List<Billing> _billings = [];

  @override
  void initState() {
    (() async {
      // 请求账本
      final paginatedBillings = await queryBillings();

      setState(() {
        // 账本列表
        _billings = paginatedBillings.items;
      });
    })();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationLayout(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Icon(
              CupertinoIcons.tickets_fill,
              color: Colors.deepOrange.shade500,
              size: 32,
            )),
        title: const Text(
          '我的账本',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
        centerTitle: false,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final billing = _billings[index];

                  return InkWell(
                    onTap: () {
                      context.pushNamed(NamedRoute.Billing.name,
                          pathParameters: {"id": billing.id.toString()});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: components.Card(
                        billing: billing,
                      ),
                    ),
                  );
                },
                childCount: _billings.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
