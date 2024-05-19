import 'package:flutter/material.dart';

enum ConfirmAction {
  Ok,
  Cancel,
}

/// 确认对话框
Future<ConfirmAction> showConfirmDialog(
  BuildContext context, {
  Widget? title,
  Widget? content,
}) async {
  return (await showDialog<ConfirmAction>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context, ConfirmAction.Cancel);
                },
              ),
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.pop(context, ConfirmAction.Ok);
                },
              ),
            ],
          );
        },
      )) ??
      ConfirmAction.Cancel;
}

/// 底部确认弹窗
Future<ConfirmAction> showConfirmBottomSheet(
  BuildContext context, {
  Widget? title,
  Widget? content,
}) async {
  final List<Widget> widgets = [];

  // 标题
  if (title != null) {
    widgets.addAll([
      title,
      const Divider(height: 32),
    ]);
  }

  if (content != null) {
    widgets.add(Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: content,
    ));
  }

  // 操作按钮
  widgets.add(Row(
    children: [
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(Colors.blue.shade50),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99))),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
            ),
            onPressed: () {
              Navigator.pop(context, ConfirmAction.Cancel);
            },
            child: const Text(
              "取消",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99))),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
            ),
            onPressed: () {
              Navigator.pop(context, ConfirmAction.Ok);
            },
            child: const Text(
              "确认",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      )
    ],
  ));

  return (await showModalBottomSheet<ConfirmAction>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          useSafeArea: true,
          showDragHandle: true,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: widgets,
                ),
              ),
            );
          })) ??
      ConfirmAction.Cancel;
}
