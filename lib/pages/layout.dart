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

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.select((UserProfile userProfile) => userProfile.isLoggedIn);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activateBottomNavigationIndex,
        onTap: (int activateIndex) => setState(() {
          _activateBottomNavigationIndex = activateIndex;
        }),
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              child: const Icon(CupertinoIcons.home),
              onTap: () => context.go('/'),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child: const Icon(
                CupertinoIcons.staroflife_fill,
              ),
              onTap: () => context.go('/statistics'),
            ),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child: const Icon(CupertinoIcons.person_fill),
              onTap: () =>
                  context.go(!isLoggedIn ? '/profile' : '/authorization'),
            ),
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
