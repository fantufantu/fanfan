import 'package:flutter/material.dart';

class Notifier {
  static void error(
    BuildContext context, {
    required String message,
  }) {
    // 展示异常信息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.redAccent.shade200,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade50,
      ),
    );
  }
}
