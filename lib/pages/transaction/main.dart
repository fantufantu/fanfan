import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Transaction extends StatefulWidget {
  final int id;

  const Transaction({
    super.key,
    required this.id,
  });

  @override
  State<Transaction> createState() => _State();
}

class _State extends State<Transaction> {
  void _edit() {
    context.pushNamed(
      NamedRoute.EditableTransaction.name,
      pathParameters: {
        "id": 1.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      backgroundColor: Colors.grey.shade50,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: Text("data"),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _edit,
                  child: const Text(
                    "修改交易",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
