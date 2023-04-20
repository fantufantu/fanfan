import 'package:flutter/material.dart';

class Billings extends StatefulWidget {
  const Billings({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State {
  @override
  Widget build(Object context) {
    return Column(
      children: [
        Text(
          UniqueKey().toString(),
        )
      ],
    );
  }
}
