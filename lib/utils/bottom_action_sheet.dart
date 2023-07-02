import 'package:flutter/material.dart';

Future<int?> showBottomActionSheet(
  BuildContext context, {
  required List<String> actions,
  Widget? title,
}) async {
  return (await showModalBottomSheet<int>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
    ),
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height / 2,
      maxWidth: double.infinity,
      minWidth: double.infinity,
    ),
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: actions
              .asMap()
              .entries
              .map(
                (e) => TextButton(
                  onPressed: () => Navigator.pop(context, e.key),
                  child: Text(e.value),
                ),
              )
              .toList(),
        ),
      );
    },
  ));
}
