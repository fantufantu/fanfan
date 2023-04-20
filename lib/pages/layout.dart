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
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey.shade500,
        ),
        selectedIconTheme: IconThemeData(
          color: Colors.blue.shade500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_square),
            activeIcon: Icon(CupertinoIcons.chart_bar_square_fill),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tickets),
            activeIcon: Icon(CupertinoIcons.tickets_fill),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: '',
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SafeArea(
          child: SizedBox.expand(child: child),
        ),
      ),
    );
  }
}
