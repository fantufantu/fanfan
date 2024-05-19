import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/billing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Editable extends StatefulWidget {
  const Editable({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Editable> {
  /// 表单唯一
  final _formKey = GlobalKey<FormState>();

  /// 账本名称
  String _name = '';

  /// 提交表单
  void _submit() {
    // 表单校验
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // 表单保存
    _formKey.currentState!.save();

    // 提交
    createBilling(name: _name).then((billing) {
      context.goNamed(NamedRoute.Billings.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 32),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(120))),
              child: Icon(
                size: 40,
                color: Colors.amber.shade500,
                CupertinoIcons.ticket_fill,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: const Text(
                "编辑属于你的账本",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              child:
                  const Text('账本用于记录你的生活中的点点滴滴，番番记账从这里出发 🎉 🎉 🎉，给它取个好听的名字吧！'),
            ),
            const Divider(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  label: Text("账本名称"),
                ),
                validator: (value) {
                  // 不能为空
                  if ((value ?? '').isEmpty) return '请输入账本名称！';
                  return null;
                },
                onSaved: (changedValue) => _name = changedValue ?? '',
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _submit,
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
                child: const Text(
                  '提交',
                  style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
