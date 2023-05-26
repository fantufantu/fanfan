import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopLayout extends StatelessWidget {
  final Widget child;

  const PopLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: null,
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
          ),
          child: child,
        ),
      ),
    );
  }
}
