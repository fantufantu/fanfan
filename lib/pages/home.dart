import 'package:fanfan/components/service_entry.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/components/billing/card.dart' as billing;

class Home extends StatelessWidget {
  const Home({super.key});

  _buildServiceEntries(BuildContext context) {
    final serviceEntryGroups = [
      [
        ServiceEntry(
          color: Colors.amber,
          label: '我的账本',
          icon: CupertinoIcons.tickets_fill,
          onPressed: () => context.go('/billings'),
        ),
        ServiceEntry(
          color: Colors.cyan,
          label: '新建账本',
          icon: CupertinoIcons.ticket_fill,
          onPressed: () => context.go('/billing/editable'),
        ),
        ServiceEntry(
          color: Colors.deepOrange,
          label: '记一笔',
          icon: CupertinoIcons.money_dollar,
          onPressed: () => context.go('/transaction/editable'),
        ),
        null
      ],
    ];

    return Wrap(
      children: (serviceEntryGroups.map(
        (serviceEntries) => Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              ...serviceEntries.map((entry) {
                if (entry == null) {
                  return Spacer();
                }

                return Expanded(
                  flex: 1,
                  child: entry,
                );
              })
            ],
          ),
        ),
      )).toList(),
    );
  }

  /// 问候语
  List<Widget> _buildGreetings(String? nickname) {
    final List<Widget> greetings = [const Text("Good morning 👋🏻")];
    if (nickname != null) {
      greetings.add(Text(
        nickname,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ));
    }
    return greetings;
  }

  @override
  Widget build(BuildContext context) {
    final nickname = context
        .select((UserProfile userProfile) => userProfile.whoAmI?.nickname);
    final defaultBilling = context.select(
        (UserProfile userProfile) => userProfile.whoAmI?.defaultBilling);

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      child: CircleAvatar(
                        child: Text("data"),
                        radius: 22,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildGreetings(nickname),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: Text("1"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: defaultBilling == null
                    ? null
                    : billing.Card(billing: defaultBilling),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 24),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Services",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    _buildServiceEntries(context),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
