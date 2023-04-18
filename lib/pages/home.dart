import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {},
            child: Text(
              context.select((UserProfile userProfile) => userProfile.token),
            ),
          ),
        ],
      ),
    );
  }
}
