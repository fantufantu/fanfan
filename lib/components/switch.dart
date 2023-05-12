import 'package:flutter/material.dart';

class Switch extends StatefulWidget {
  const Switch({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Switch> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(isSelected: const [
      false,
      true
    ], children: const [
      Text("out"),
      Text("in"),
    ]);
  }
}
