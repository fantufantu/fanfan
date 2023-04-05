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

  final _formKey = GlobalKey<FormState>();

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
                      decoration: const InputDecoration(
                        label: Text('邮箱'),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 28),
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: const Text('密码'),
                        prefixIcon: const Icon(
                          Icons.lock_rounded,
                          size: 16,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.remove_red_eye_rounded,
                            size: 16,
                          ),
                        ),
                      ),
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
                      onPressed: () {
                        _formKey.currentState?.validate();
                        _formKey.currentState?.save();
                      },
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
    );
  }
}
