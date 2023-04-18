import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Layout extends StatelessWidget {
  Widget child;

  Layout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => _Layout(child: child);
}

class _Layout extends StatefulWidget {
  Widget child;

  _Layout({required this.child});

  @override
  _LayoutState createState() => _LayoutState(child: child);
}

class _LayoutState extends State<_Layout> {
  /// 子组件
  Widget child;

  /// 当前激活的底部下标
  int _activateBottomNavigationIndex = 0;

  _LayoutState({required this.child});

  _navigate({
    required int activateIndex,
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    print(activateIndex);
    // 路由切换
    switch (activateIndex) {
      case 0:
        print("22222");
        context.go('/sss');
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

    // 下标变更
    setState(() {
      _activateBottomNavigationIndex = activateIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.select((UserProfile userProfile) => userProfile.isLoggedIn);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activateBottomNavigationIndex,
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
