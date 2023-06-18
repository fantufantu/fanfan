import 'package:fanfan/router/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Widget? title;
  final bool? centerTitle;
  final Widget? floatingActionButton;
  final VoidCallback? onPop;

  const PopLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.centerTitle,
    this.floatingActionButton,
    this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: null,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: title,
        centerTitle: centerTitle,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
            onPressed: onPop ??
                () => context.canPop()
                    ? context.pop()
                    : context.goNamed(NamedRoute.Home.name),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: SafeArea(
          child: child,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
