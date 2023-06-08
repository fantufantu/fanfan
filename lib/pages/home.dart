import 'package:fanfan/components/service_entry.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:fanfan/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/components/billing/card.dart' as components show Card;

class Home extends StatelessWidget {
  const Home({super.key});

  _buildServiceEntries(
    BuildContext context, {
    int? defaultBillingId,
  }) {
    final serviceEntries = [
      ServiceEntry(
        color: Colors.amber,
        label: '我的账本',
        icon: CupertinoIcons.tickets_fill,
        onPressed: () => context.goNamed(NamedRoute.Billings.name),
      ),
      ServiceEntry(
        color: Colors.cyan,
        label: '新建账本',
        icon: CupertinoIcons.ticket_fill,
        onPressed: () => context.pushNamed(NamedRoute.EditableBilling.name),
      ),
      ServiceEntry(
        color: Colors.deepOrange,
        label: '记一笔',
        icon: CupertinoIcons.money_dollar,
        onPressed: () => context.pushNamed(NamedRoute.EditableTransaction.name),
      ),
      ServiceEntry(
        color: Colors.purple,
        label: '交易记录',
        icon: CupertinoIcons.bitcoin,
        onPressed: () {
          // 当前用户没有设置默认账本时，消息提醒用户设置
          if (defaultBillingId != null) {
            Notifier.error();
            return;
          }

          // 存在默认账本，直接跳转到默认账本对应的交易记录
          context.pushNamed(NamedRoute.Transactions.name, pathParameters: {
            "billingId": defaultBillingId.toString(),
          });
        },
      ),
      ServiceEntry(
        color: Colors.red,
        label: '心愿单',
        icon: CupertinoIcons.heart_fill,
        onPressed: () => context.pushNamed(NamedRoute.EditableTransaction.name),
      ),
    ];

    const double SPACING = 20;

    return Padding(
      padding: const EdgeInsets.all(SPACING),
      child: Wrap(
        spacing: SPACING,
        runSpacing: SPACING,
        children: serviceEntries,
      ),
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
    final avatar =
        context.select((UserProfile userProfile) => userProfile.whoAmI?.avatar);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: CustomScrollView(
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
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              avatar != null ? NetworkImage(avatar) : null,
                          child: const Icon(CupertinoIcons.person),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildGreetings(nickname),
                        ),
                      ),
                      const Spacer(),
                      Icon(CupertinoIcons.bell, color: Colors.grey.shade600),
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: Icon(
                          CupertinoIcons.ellipsis_circle,
                          color: Colors.grey.shade600,
                        ),
                      )
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
                      : components.Card(billing: defaultBilling),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return Container(
                  padding: const EdgeInsets.only(top: 24),
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
                      _buildServiceEntries(
                        context,
                        defaultBillingId: defaultBilling?.id,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
