import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Editable extends StatefulWidget {
  const Editable({
    super.key,
  });

  @override
  State<Editable> createState() => _State();
}

class _State extends State<Editable> {
  /// 用户名
  late final String username;

  @override
  void initState() {
    super.initState();

    // 全局存储的用户
    final userProfile = context.read<UserProfile>().whoAmI!;
    // 用户名
    username = userProfile.username ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      centerTitle: false,
      title: const Text(
        "修改信息",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Form(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: TextFormField(
                                  initialValue: username,
                                  decoration: const InputDecoration(
                                    label: Text("用户名称"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, bottom: 12),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
                ),
                child: const Text(
                  "更新",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
