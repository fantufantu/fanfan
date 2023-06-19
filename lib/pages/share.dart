import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/service/api/sharing.dart';
import 'package:fanfan/service/api/user.dart';
import 'package:fanfan/service/entities/user/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import "package:fanfan/components/user/thumbnail.dart";
import 'package:fanfan/service/entities/sharing/main.dart';

class Share extends StatefulWidget {
  final Type type;
  final int target;

  const Share({
    super.key,
    required this.type,
    required this.target,
  });

  @override
  State<Share> createState() => _State();
}

class _State extends State<Share> {
  late List<User> _users;
  late PublishSubject<String> _userSearcher;

  @override
  void initState() {
    super.initState();

    _users = [];
    _userSearcher = PublishSubject<String>()
      ..debounceTime(
        const Duration(seconds: 1),
      ).asyncMap<List<User>>(
        (who) async {
          return who.isEmpty ? [] : await queryUsers(who);
        },
      ).listen((users) {
        setState(() {
          _users = users;
        });
      });
  }

  _onShare(int userId) async {
    final isSucceed = await createSharing(
      targetId: widget.target,
      targetType: widget.type,
      sharedById: userId,
    );

    if (isSucceed) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      backgroundColor: Colors.grey.shade50,
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
              onChanged: (value) {
                _userSearcher.add(value);
              },
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
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              _onShare(_users.elementAt(index).id!);
                            },
                            child: Thumbnail(
                              user: _users.elementAt(index),
                            ),
                          ),
                        );
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
