import 'dart:async';

import 'package:fanfan/service/authorization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignUpForm();
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  /// 是否记住我
  bool _isRememberMe = false;

  /// 邮箱
  String _emailAddress = '';

  /// 密码
  String _password = '';

  /// 验证码
  String _captcha = '';

  /// 倒计时
  int countdown = 0;

  /// 是否密码可见
  bool _isPasswordVisable = false;

  /// 是否表单填写完整
  get isCompleted {
    return _emailAddress.isNotEmpty &&
        _password.isNotEmpty &&
        _captcha.isNotEmpty;
  }

  /// 注册 api
  // final registerMutation = useMutation(MutationOptions(document: REGISTER));

  /// 注册
  useRegister() {
    if (!isCompleted) return null;
    return () {
      // // 请求
      // final registered = registerMutation.runMutation({
      //   'registerBy': {
      //     'emailAddress': _emailAddress,
      //     'captcha': _captcha,
      //     'password': _password,
      //   }
      // });

      // print("registered=====");
      // print(registered);
    };
  }

  final _formKey = GlobalKey<FormState>();

  /// 开启倒计时
  onCaptchaSent() {
    setState(() {
      countdown = 60;
    });

    // 定时器
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        return;
      }
      // - 1 秒
      setState(() {
        countdown = countdown - 1;
      });
    });
  }

  /// 切换是否密码可见
  onIsPasswordVisableChange() {
    setState(() {
      _isPasswordVisable = !_isPasswordVisable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: const Text(
                      'Create your',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 12,
                    ),
                    child: const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: TextFormField(
                      initialValue: _emailAddress,
                      decoration: const InputDecoration(
                        label: Text('邮箱'),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          size: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _emailAddress = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      initialValue: _captcha,
                      decoration: InputDecoration(
                        label: const Text('验证码'),
                        prefixIcon: const Icon(
                          Icons.fingerprint_rounded,
                          size: 16,
                        ),
                        suffix: countdown == 0
                            ? InkWell(
                                onTap: onCaptchaSent,
                                child: Text(
                                  '发送验证码',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              )
                            : Text(
                                '倒计时 $countdown s',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _captcha = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      initialValue: _password,
                      obscureText: !_isPasswordVisable,
                      decoration: InputDecoration(
                        label: const Text('密码'),
                        prefixIcon: const Icon(
                          Icons.lock_rounded,
                          size: 16,
                        ),
                        suffixIcon: InkWell(
                          onTap: onIsPasswordVisableChange,
                          child: Icon(
                            _isPasswordVisable
                                ? Icons.remove_red_eye_rounded
                                : Icons.password_rounded,
                            size: 16,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isRememberMe,
                          onChanged: (changed) => setState(() {
                            _isRememberMe = changed == true;
                          }),
                        ),
                        const Text('Remember me')
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                    ),
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: useRegister(),
                      style: const ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      child: const Text('Sign up'),
                    ),
                  ),
                ],
              ),
            ),
            childCount: 1,
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => context.go('/authorization/sign-in'),
                    child: const Text("Sign in"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
