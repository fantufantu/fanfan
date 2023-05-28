import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/service/api/authorization.dart';
import 'package:fanfan/utils/application.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  /// 记住我
  bool _isRememberMe = false;

  /// 用户凭证
  String _who = 'tutu@fantufantu.com';

  /// 密码
  String _password = 'hjz+++0502';

  /// 是否密码可见
  bool _isPasswordVisable = false;

  final _formKey = GlobalKey<FormState>();

  /// 是否表单填写完整
  get _isCompleted {
    return _who.isNotEmpty && _password.isNotEmpty;
  }

  /// 切换是否密码可见
  _onIsPasswordVisableChange() {
    setState(() {
      _isPasswordVisable = !_isPasswordVisable;
    });
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
                child: const Text("登录成功，正在跳转..."),
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  /// 登录触发器
  _useLogin(BuildContext context) {
    if (!_isCompleted) return null;

    // 登录
    return () => login(
          who: _who,
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
              dismissDirection: DismissDirection.up,
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

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      child: CustomScrollView(
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
                        initialValue: _who,
                        decoration: const InputDecoration(
                          label: Text('邮箱'),
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            size: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _who = value;
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
                        onPressed: _useLogin(context),
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        child: const Text('Sign in'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            '忘记密码',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
                    const Text('Don`t have an account?'),
                    TextButton(
                      onPressed: () => context.go('/authorization/sign-up'),
                      child: const Text("Sign up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
