import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () => {context.go('/')},
            icon: const Icon(Icons.arrow_back),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ),
      body: const _SignIn(),
    );
  }
}

class _SignIn extends StatefulWidget {
  const _SignIn();

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<_SignIn> {
  /// 用户名、邮箱
  String keyword = '';

  /// 密码
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: Text("请输入用户名"),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("请输入密码"),
            ),
          ),
        ],
      ),
    );
  }
}
