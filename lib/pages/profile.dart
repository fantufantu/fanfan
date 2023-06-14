import 'dart:math';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/pages/loading.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:fanfan/utils/confirm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  /// 功能
  Widget _buildServices(
    BuildContext context, {
    required UserProfile userProfile,
  }) {
    final services = [
      _Service(
        leading: CupertinoIcons.square_arrow_left,
        title: '登出',
        isLink: false,
        onClick: () async {
          final aciton = await showConfirmDialog(context,
              title: const Text("用户确认"),
              content: const Text(
                "确认退出登录吗？",
                style: TextStyle(
                  color: Colors.red,
                ),
              ));

          // 用户取消
          if (aciton == ConfirmAction.Cancel) return;
          // 退出登录
          final isLoggedOut = await userProfile.logout();
          // 登出失败，不执行跳转
          if (!isLoggedOut) return;
          context.goNamed(NamedRoute.Authorization.name);
        },
        color: Colors.red,
        rotateAngle: pi,
      )
    ];

    return Column(
      children: services
          .map(
            (item) => InkWell(
              onTap: item.onClick,
              child: Row(
                children: [
                  Transform.rotate(
                    angle: item.rotateAngle,
                    child: Icon(
                      item.leading,
                      color: item.color,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: item.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();
    final whoAmI = userProfile.whoAmI;

    if (whoAmI == null) {
      return const Loading();
    }

    return NavigationLayout(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/user/preset.png'),
              radius: 60,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                whoAmI.nickname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(whoAmI.emailAddress!),
            ),
            const Divider(height: 40),
            // 服务列表
            _buildServices(context, userProfile: userProfile),
          ],
        ),
      ),
    );
  }
}

class _Service {
  _Service({
    required this.leading,
    required this.title,
    required this.isLink,
    required this.onClick,
    required this.color,
    required rotateAngle,
  }) : _rotateAngle = rotateAngle ?? 0;

  final IconData leading;
  final String title;
  final bool isLink;
  final Color color;
  final double _rotateAngle;
  final void Function()? onClick;

  double get rotateAngle {
    return _rotateAngle;
  }
}
