import 'dart:math';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/layouts/loading_layout.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:fanfan/utils/confirm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  late final List<_Service> _services;

  @override
  void initState() {
    super.initState();

    /// 功能列表数据
    _services = [
      _Service(
        leading: CupertinoIcons.person,
        title: '修改信息',
        isLink: true,
        onClick: () {
          context.pushNamed(NamedRoute.EditableProfile.name);
        },
      ),
      _Service(
        leading: CupertinoIcons.square_arrow_left,
        title: '登出',
        isLink: false,
        onClick: () async {
          final aciton = await showConfirmBottomSheet(
            context,
            title: const Text("用户确认"),
            content: const Text(
              "确认退出登录吗？",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          );
          // 用户取消
          if (aciton == ConfirmAction.Cancel) return;
          // 退出登录
          final isLoggedOut = await context.read<UserProfile>().logout();
          // 登出失败，不执行跳转
          if (!isLoggedOut) return;
          context.goNamed(NamedRoute.Authorization.name);
        },
        color: Colors.red,
        rotateAngle: pi,
      )
    ];
  }

  /// 渲染功能列表
  Widget _buildServices() {
    return Column(
      children: _services
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: item.onClick,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                    const Spacer(),
                    Container(
                      child: item.isLink
                          ? Icon(
                              CupertinoIcons.right_chevron,
                              color: Colors.grey.shade600,
                              size: 20,
                            )
                          : null,
                    )
                  ],
                ),
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
      return const LoadingLayout();
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
            _buildServices(),
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
    required this.onClick,
    required this.isLink,
    this.color,
    rotateAngle,
  }) : _rotateAngle = rotateAngle ?? 0;

  final IconData leading;
  final String title;
  final bool isLink;
  final Color? color;
  final double? _rotateAngle;
  final void Function()? onClick;

  double get rotateAngle {
    return _rotateAngle ?? 0;
  }
}
