import 'package:fanfan/service/api/billing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Editable extends StatelessWidget {
  /// 表单唯一
  final _formKey = GlobalKey<FormState>();

  /// 账本名称
  String _name = '';

  /// 提交表单
  _useSubmit(BuildContext context) {
    return () {
      // 表单校验
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      // 表单保存
      _formKey.currentState!.save();

      // 提交
      createBilling(name: _name).then((billing) {
        print(billing);
      }).catchError((error) {
        print(error);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 32),
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.all(Radius.circular(120))),
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
          child: const Text('账本用于记录你的生活中的点点滴滴，番番记账从这里出发 🎉 🎉 🎉，给它取个好听的名字吧！'),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: const Divider(),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Form(
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
        ),
        Spacer(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 8),
          child: ElevatedButton(
            onPressed: _useSubmit(context),
            child: Text(
              '提交',
              style: TextStyle(
                letterSpacing: 4,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28))),
                elevation: MaterialStatePropertyAll(8)),
          ),
        ),
      ],
    );
  }
}
