import 'package:fanfan/service/entities/who_am_i.dart';
import 'package:flutter/material.dart';

class Thumbnail extends StatefulWidget {
  final WhoAmI user;

  const Thumbnail({
    super.key,
    required this.user,
  });

  @override
  State<Thumbnail> createState() => _State();
}

class _State extends State<Thumbnail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(widget.user.username),
    );
  }
}
