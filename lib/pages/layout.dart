import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Layout extends StatelessWidget {
  final Widget child;

  const Layout({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith('/statistics')) {
      return 1;
    }
    if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }

  _navigate({
    required int activateIndex,
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    // 路由切换
    switch (activateIndex) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/statistics');
        break;
      case 2:
        if (isLoggedIn) {
          context.go('/profile');
          break;
        }
        context.go('/authorization');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.select((UserProfile userProfile) => userProfile.isLoggedIn);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int activateIndex) => _navigate(
          activateIndex: activateIndex,
          context: context,
          isLoggedIn: isLoggedIn,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.staroflife_fill,
            ),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: "Profile",
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: SafeArea(
          child: SizedBox.expand(child: child),
        ),
      ),
    );
  }
}
