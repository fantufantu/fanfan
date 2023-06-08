import 'package:fanfan/layouts/main.dart';
import 'package:flutter/cupertino.dart';

class LimitSettings extends StatefulWidget {
  final int id;

  const LimitSettings({
    super.key,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LimitSettings> {
  @override
  Widget build(BuildContext context) {
    return const PopLayout(
      child: Text("data"),
    );
  }
}
