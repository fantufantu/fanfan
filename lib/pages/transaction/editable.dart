import 'package:fanfan/components/form/date_picker_form_field.dart';
import 'package:fanfan/components/form/picker_form_field.dart';
import 'package:fanfan/components/form/switch_form_field.dart';
import 'package:fanfan/components/picker.dart';
import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/store/category.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/components/billing/card.dart' as components show Card;
import 'package:tuple/tuple.dart';
import 'package:fanfan/service/entities/transaction.dart' as entities
    show Transaction, Direction;

class Editable extends StatefulWidget {
  const Editable({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Editable> {
  /// 表单唯一
  final _formKey = GlobalKey<FormState>();

  /// 交易实体
  late entities.Transaction _transaction;

  /// 交易所属账本
  Billing? _belongTo;

  /// 交易方向
  final List<entities.Direction> _directions = [
    entities.Direction.Out,
    entities.Direction.In,
  ];

  @override
  void initState() {
    super.initState();

    // 默认交易
    _transaction = entities.Transaction.initialize();
    // 默认账本
    _belongTo = context.read<UserProfile>().whoAmI?.defaultBilling;
  }

  @override
  Widget build(BuildContext context) {
    /// 分类
    final categories = context
        .select((Category category) => category.categories)
        .map((e) => SelectOption(value: e.id, label: e.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              context.canPop() ? context.pop() : context.go('/');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) {
                      return Column(
                        children: [
                          _belongTo != null
                              ? components.Card(
                                  billing: _belongTo!,
                                  elevation: 0,
                                )
                              : ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ))),
                                  child: const Text("请选择")),
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
                              child: Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: Text("金额：")),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      initialValue: _transaction.remark,
                                      textAlign: TextAlign.end,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      onSaved: (value) {
                                        _transaction.amount =
                                            double.tryParse(value!);
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                24, 12, 24, 12),
                                        prefix: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: Text("发生时间：")),
                                  Expanded(
                                    flex: 3,
                                    child: DatePickerFormField(
                                      initialValue: _transaction.happenedAt,
                                      mode: CupertinoDatePickerMode.date,
                                      onSaved: (value) {
                                        _transaction.happenedAt = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: Text("选择分类：")),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: categories.isNotEmpty
                                          ? PickerFormField(
                                              options: categories,
                                              onSaved: (value) {
                                                print(value);
                                                _transaction.categoryId =
                                                    value == null
                                                        ? null
                                                        : categories
                                                            .elementAt(value)
                                                            .value;
                                              },
                                            )
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: Text("备注：")),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      minLines: 3,
                                      maxLines: 8,
                                      onSaved: (value) {
                                        _transaction.remark = value;
                                      },
                                    ),
                                  ),
                                ],
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
                          onPressed: () {
                            _formKey.currentState?.save();

                            print(_transaction.toJson());
                          },
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
        ),
      ),
    );
  }
}
