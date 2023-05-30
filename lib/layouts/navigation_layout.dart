import 'package:fanfan/router/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  NavigationLayout({
    super.key,
    required this.child,
    this.appBar,
  });

  final _navigationItems = [
    const _NavigationItem(
      icon: Icon(CupertinoIcons.house),
      activeIcon: Icon(CupertinoIcons.house_fill),
      routeName: NamedRoute.Home,
    ),
    const _NavigationItem(
      icon: Icon(CupertinoIcons.chart_bar_square),
      activeIcon: Icon(CupertinoIcons.chart_bar_square_fill),
      routeName: NamedRoute.Statistics,
    ),
    const _NavigationItem(
      icon: Icon(CupertinoIcons.tickets),
      activeIcon: Icon(CupertinoIcons.tickets_fill),
      routeName: NamedRoute.Billings,
    ),
    const _NavigationItem(
      icon: Icon(CupertinoIcons.person),
      activeIcon: Icon(CupertinoIcons.person_fill),
      routeName: NamedRoute.Profile,
      guardRouteName: NamedRoute.Authorization,
    )
  ];

  /// 根据路由计算所在的导航位置
  int _calculateSelectedIndex(BuildContext context) {
    return ['/statistics', '/billings', '/profile']
            .indexOf(GoRouterState.of(context).location) +
        1;
  }

  /// 路由导航
  _navigate(
    BuildContext context, {
    required int activeIndex,
  }) {
    final isLoggedIn = context.read<UserProfile>().isLoggedIn;
    context
        .goNamed(_navigationItems.elementAt(activeIndex).to(isLoggedIn).name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int activeIndex) => _navigate(
          context,
          activeIndex: activeIndex,
        ),
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey.shade500,
        ),
        selectedIconTheme: IconThemeData(
          color: Colors.blue.shade500,
        ),
        items: _navigationItems
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  label: "",
                ))
            .toList(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      appBar: appBar,
      body: SafeArea(
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

/// 导航条目
class _NavigationItem {
  final Widget icon;
  final Widget activeIcon;
  final NamedRoute routeName;
  final NamedRoute? guardRouteName;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.routeName,
    this.guardRouteName,
  });

  NamedRoute to(bool? isLoggedIn) {
    return isLoggedIn == null
        ? routeName
        : isLoggedIn
            ? routeName
            : (guardRouteName ?? routeName);
  }
}