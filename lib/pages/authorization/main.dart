import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Authorization extends StatelessWidget {
  final Widget child;

  const Authorization({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              context.canPop() ? context.pop() : context.go('/');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
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