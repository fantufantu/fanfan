import 'package:flutter/material.dart';
import 'package:fanfan/components/loading.dart';

class LoadingLayout extends StatelessWidget {
  const LoadingLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loading(),
    );
  }
}
