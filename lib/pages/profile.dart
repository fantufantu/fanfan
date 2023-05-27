import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final whoAmI =
        context.select((UserProfile userProfile) => userProfile.whoAmI)!;

    return NavigationLayout(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/user/preset.png'),
            radius: 60,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              whoAmI.nickname,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Text(whoAmI.emailAddress),
          ),
          const Divider(height: 40),
        ],
      ),
    );
  }
}
