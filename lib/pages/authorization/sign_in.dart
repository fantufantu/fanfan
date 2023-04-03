import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignInForm();
  }
}

class _SignInForm extends StatefulWidget {
  const _SignInForm();

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  /// 用户名、邮箱
  String _keyword = '';

  /// 密码
  String _password = '';

  /// 记住我
  bool _isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 28,
            ),
            child: const Text(
              'Login to your',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 12,
              bottom: 40,
            ),
            child: const Text(
              'Account',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("请输入用户名"),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.black12,
              focusColor: Colors.black45,
              hoverColor: Colors.black45,
              floatingLabelStyle: TextStyle(
                color: Colors.transparent,
              ),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("请输入密码"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  value: _isRememberMe,
                  onChanged: (changed) => setState(() {
                    _isRememberMe = changed == true;
                  }),
                ),
                const Text('记住我')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
