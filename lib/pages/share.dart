import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/service/entities/who_am_i.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Share extends StatefulWidget {
  const Share({
    super.key,
  });

  @override
  State<Share> createState() => _State();
}

class _State extends State<Share> {
  late String _who;
  late List<WhoAmI> _users;

  @override
  void initState() {
    super.initState();

    _who = '';
    _users = [];
  }

  /// 防抖模糊搜索用户
  void _searchUsers(String value) {}

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      title: const Text(
        "搜索用户",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
        child: Column(
          children: [
            TextField(
              onChanged: _searchUsers,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("相关用户："),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Text("data");
                      },
                      childCount: _users.length,
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
