import 'package:fanfan/components/form/date_picker_form_field.dart';
import 'package:fanfan/components/form/picker_form_field.dart';
import 'package:fanfan/components/form/switch_form_field.dart';
import 'package:fanfan/components/picker.dart';
import 'package:fanfan/service/api/transaction.dart';
import 'package:fanfan/store/category.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fanfan/layouts/main.dart' show PopLayout;
import 'package:provider/provider.dart';
import 'package:fanfan/components/billing/card.dart' as components show Card;
import 'package:tuple/tuple.dart';
import 'package:fanfan/service/entities/transaction/main.dart' as entities
    show Direction;
import 'package:fanfan/service/entities/transaction/editable.dart' as entities
    show Editable;

class Editable extends StatefulWidget {
  const Editable({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Editable> {
  /// 表单唯一
  final _formKey = GlobalKey<FormState>();

  /// 交易实体
  late entities.Editable _transaction;

  /// 交易方向
  final List<entities.Direction> _directions = [
    entities.Direction.Out,
    entities.Direction.In,
  ];

  @override
  void initState() {
    super.initState();

    // 页面入参没有id时，初始化默认的编辑数据
    _transaction = entities.Editable(
      amount: 0,
      billing: context.read<UserProfile>().whoAmI?.defaultBilling,
      direction: entities.Direction.Out,
      happenedAt: DateTime.now(),
      remark: "",
      categoryId: null,
    );

    // 页面传入id，请求服务端获取对应的交易数据
  }

  /// 渲染交易归属账本
  Widget _buildBelongTo() {
    // 没有选择账本时，展现一个选择账本的入口
    if (_transaction.billing == null) {
      return ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ))),
          child: const Text("请选择"));
    }

    // 利用卡片组件展现账本的简要信息
    return components.Card(
      billing: _transaction.billing!,
      elevation: 0,
    );
  }

  _submit() async {
    // 保存表单数据
    _formKey.currentState?.save();

    // 向服务端请求
    await createTransaction(editable: _transaction);
  }

  @override
  Widget build(BuildContext context) {
    /// 分类
    final categories = context
        .select((Category category) => category.categories)
        .map((e) => SelectOption(value: e.id, label: e.name))
        .toList();

    return PopLayout(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Column(
                    children: [
                      _buildBelongTo(),
                      const Divider(height: 32),
                    ],
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SwitchFormField(
                          initialValue:
                              _directions.indexOf(_transaction.direction!),
                          children: const Tuple2("支出", "收入"),
                          onSaved: (value) {
                            _transaction.direction =
                                _directions.elementAt(value!);
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            initialValue: (_transaction.amount != 0
                                ? _transaction.amount.toString()
                                : null),
                            textAlign: TextAlign.end,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onSaved: (value) {
                              _transaction.amount = double.tryParse(value!);
                            },
                            decoration: InputDecoration(
                              labelText: "金额",
                              contentPadding:
                                  const EdgeInsets.fromLTRB(24, 12, 24, 12),
                              prefix: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  "CNY",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: DatePickerFormField(
                            initialValue: _transaction.happenedAt,
                            mode: CupertinoDatePickerMode.date,
                            onSaved: (value) {
                              _transaction.happenedAt = value;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: PickerFormField(
                            options: categories,
                            placeholder: "请选择分类",
                            onSaved: (value) {
                              _transaction.categoryId = value == null
                                  ? null
                                  : categories.elementAt(value).value;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            minLines: 3,
                            maxLines: 8,
                            onSaved: (value) {
                              _transaction.remark = value;
                            },
                            decoration: const InputDecoration(
                              labelText: "备注",
                              alignLabelWithHint: true,
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.all(16)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28))),
                          elevation: const MaterialStatePropertyAll(8)),
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
            )
          ],
        ),
      ),
    );
  }
}
