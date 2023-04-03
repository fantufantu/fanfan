import 'package:flutter/material.dart';

class HowToAuthorize extends StatelessWidget {
  const HowToAuthorize({super.key});

  @override
  Widget build(context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: 1,
            (context, index) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Image.asset(
                    "images/unauthorized.png",
                    width: double.infinity,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: const Text(
                      'Let`s you in',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      "or",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 14),
                child: const Text(
                  '用账号密码方式',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
