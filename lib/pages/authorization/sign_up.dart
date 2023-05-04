import 'dart:async';
import 'package:fanfan/service/api/authorization.dart';
import 'package:fanfan/utils/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  int _countdown = 0;

  /// 是否密码可见
  bool _isPasswordVisable = false;

  /// 是否表单填写完整
  get _isCompleted {
    return _emailAddress.isNotEmpty &&
        _password.isNotEmpty &&
        _captcha.isNotEmpty;
  }

  /// 展示正在跳转的弹窗
  _loadingForNavigating(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.run_circle,
                size: 80,
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: const Text("注册成功，正在跳转..."),
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  /// 注册
  _useRegister(BuildContext context) {
    if (!_isCompleted) return null;

    // 注册
    return () => register(
          emailAddress: _emailAddress,
          captcha: _captcha,
          password: _password,
        ).then((token) {
          // 显示对话框正在登录
          _loadingForNavigating(context);
          // 尝试重新初始化应用
          reinitialize(token).then((_) {
            // 跳转到首页
            context.go('/');
          });
        }).catchError((error) {
          // 展示异常信息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error.message,
                    style: TextStyle(
                      color: Colors.redAccent.shade200,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.grey.shade50,
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();

  /// 发送验证码，开启倒计时
  _onCaptchaSent(BuildContext context) async {
    await sendCaptcha(
      to: _emailAddress,
      type: describeEnum(VerificationType.Email),
    ).catchError((error) {
      // 展示异常信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error.message,
                style: TextStyle(
                  color: Colors.redAccent.shade200,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.grey.shade50,
        ),
      );

      throw error;
    });

    setState(() {
      _countdown = 60;
    });

    // 定时器
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        return;
      }
      // - 1 秒
      setState(() {
        _countdown = _countdown - 1;
      });
    });
  }

  /// 切换是否密码可见
  _onIsPasswordVisableChange() {
    setState(() {
      _isPasswordVisable = !_isPasswordVisable;
    });
  }

  /// 发送验证码触发器
  Widget _buildCaptchaSender(BuildContext context) {
    // 开启倒计时
    if (_countdown > 0) {
      return Text(
        '倒计时 $_countdown s',
        style: const TextStyle(
          fontSize: 12,
        ),
      );
    }

    // 不可用文本
    if (_emailAddress.isEmpty) {
      return const Text(
        '发送验证码',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      );
    }

    // 发送按钮
    return InkWell(
      onTap: _emailAddress.isNotEmpty ? () => _onCaptchaSent(context) : null,
      child: Text(
        '发送验证码',
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue.shade700,
        ),
      ),
    );
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
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _captcha,
                            decoration: const InputDecoration(
                              label: Text('验证码'),
                              prefixIcon: Icon(
                                Icons.fingerprint_rounded,
                                size: 16,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _captcha = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCaptchaSender(context),
                            ],
                          ),
                        ),
                      ],
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
                          onTap: _onIsPasswordVisableChange,
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
                      onPressed: _useRegister(context),
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
