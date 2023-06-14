import 'package:fanfan/router/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationLayout extends StatelessWidget {
  final Widget child;

  NavigationLayout({
    super.key,
    required this.child,
  });

  final _navigationItems = [
    const _NavigationItem(
      icon: Icon(CupertinoIcons.house),
      activeIcon: Icon(CupertinoIcons.house_fill),
      routeName: NamedRoute.Home,
      label: "主页",
    ),
    _NavigationItem(
      icon: const Icon(CupertinoIcons.chart_bar_square),
      activeIcon: const Icon(CupertinoIcons.chart_bar_square_fill),
      routeName: NamedRoute.Statistics,
      label: "统计",
      appBar: _AppBar(
        title: 'Statistics',
        leading: _Leading(
          icon: CupertinoIcons.chart_bar_square_fill,
          color: Colors.amber.shade500,
        ),
        backgroundColor: Colors.grey.shade50,
      ),
    ),
    _NavigationItem(
      icon: const Icon(CupertinoIcons.tickets),
      activeIcon: const Icon(CupertinoIcons.tickets_fill),
      routeName: NamedRoute.Billings,
      label: "账本",
      appBar: _AppBar(
        title: '我的账本',
        leading: _Leading(
          icon: CupertinoIcons.tickets_fill,
          color: Colors.blueGrey.shade500,
        ),
      ),
    ),
    _NavigationItem(
      icon: const Icon(CupertinoIcons.person),
      activeIcon: const Icon(CupertinoIcons.person_fill),
      routeName: NamedRoute.Profile,
      guardRouteName: NamedRoute.Authorization,
      label: "我的",
      appBar: _AppBar(
        title: '关于我',
        leading: _Leading(
          icon: CupertinoIcons.person_fill,
          color: Colors.orange.shade500,
        ),
      ),
    )
  ];

  /// 根据路由计算所在的导航位置
  int _calculateSelectedIndex(BuildContext context) {
    return _navigationItems.indexWhere(
        (item) => item.routeName.name == GoRouterState.of(context).name);
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
    // 当前导航所在索引
    final selectedIndex = _calculateSelectedIndex(context);
    // 当前导航
    final selectedNavigationItem = _navigationItems.elementAt(selectedIndex);

    return Scaffold(
      appBar: selectedNavigationItem.appBar != null
          ? AppBar(
              elevation: 0,
              backgroundColor: selectedNavigationItem.appBar!.backgroundColor,
              leading: selectedNavigationItem.appBar!.leading != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Icon(
                        selectedNavigationItem.appBar!.leading!.icon,
                        color: selectedNavigationItem.appBar!.leading!.color,
                        size: 32,
                      ),
                    )
                  : null,
              title: Text(
                selectedNavigationItem.appBar!.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: false,
            )
          : null,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
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
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            height: 2,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            height: 2,
            fontSize: 12,
          ),
          items: _navigationItems
              .map((item) => BottomNavigationBarItem(
                    icon: item.icon,
                    activeIcon: item.activeIcon,
                    label: item.label,
                  ))
              .toList(),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
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
  final String label;
  final _AppBar? appBar;
  final NamedRoute? guardRouteName;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.routeName,
    required this.label,
    this.guardRouteName,
    this.appBar,
  });

  NamedRoute to(bool? isLoggedIn) {
    return isLoggedIn == null
        ? routeName
        : isLoggedIn
            ? routeName
            : (guardRouteName ?? routeName);
  }
}

class _AppBar {
  final String title;
  final _Leading? leading;
  final Color? backgroundColor;

  _AppBar({
    required this.title,
    this.leading,
    this.backgroundColor,
  });
}

class _Leading {
  final IconData icon;
  final Color? color;

  _Leading({
    required this.icon,
    this.color,
  });
}
