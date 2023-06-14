import 'package:fanfan/service/entities/user.dart';
import 'package:flutter/material.dart';

class Thumbnail extends StatefulWidget {
  final User user;

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
      child: Column(
        children: [
          Text(widget.user.username!),
          Text(widget.user.emailAddress!),
        ],
      ),
    );
  }
}
