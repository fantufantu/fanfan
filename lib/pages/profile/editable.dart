import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/service/api/user.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/service/entities/user/editable.dart' as entities
    show Editable;

class Editable extends StatefulWidget {
  const Editable({
    super.key,
  });

  @override
  State<Editable> createState() => _State();
}

class _State extends State<Editable> {
  /// 表单唯一
  final _formKey = GlobalKey<FormState>();

  /// 用户名
  late final entities.Editable _user;

  @override
  void initState() {
    super.initState();

    // 全局存储的用户
    final userProfile = context.read<UserProfile>().whoAmI!;
    // 表单内容
    _user = entities.Editable(
      nickname: userProfile.nickname,
    );
  }

  /// 提交表单
  _submit() async {
    // 表单校验
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState!.save();

    // 调用接口
    final isSucceed = await updateUser(_user);
    if (!isSucceed) return;

    // 更新全局存储的用户信息
    context.read<UserProfile>().update(_user);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      centerTitle: false,
      title: const Text(
        "修改信息",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: TextFormField(
                                  initialValue: _user.nickname,
                                  onSaved: (newValue) {
                                    _user.nickname = newValue;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text("用户名称"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, bottom: 12),
              child: ElevatedButton(
                onPressed: _submit,
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.all(16),
                  ),
                ),
                child: const Text(
                  "更新",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
