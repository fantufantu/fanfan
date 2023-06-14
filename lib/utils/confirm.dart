import 'package:flutter/material.dart';

enum ConfirmAction {
  Ok,
  Cancel,
}

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
