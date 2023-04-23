import 'package:fanfan/components/service_entry.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
        null,
        null
      ],
    ];

    return Wrap(
      children: [
        ...(serviceEntryGroups.map(
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
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final username =
        context.select((UserProfile userProfile) => userProfile.userAlias);

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
                        children: [
                          Text("Good morning 👋🏻"),
                          Text(
                            username,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
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
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(32),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    boxShadow: kElevationToShadow[3],
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    image: DecorationImage(
                      image: AssetImage('images/billing/background/blue.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text("data",
                      style: TextStyle(
                        color: Colors.white,
                      )),
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
                margin: EdgeInsets.only(top: 24),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
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
