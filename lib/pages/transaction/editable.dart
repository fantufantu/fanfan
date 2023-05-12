import 'package:fanfan/components/date_picker.dart';
import 'package:fanfan/components/picker.dart';
import 'package:fanfan/store/category.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/components/billing/card.dart' as billing_components
    show Card;
import 'package:fanfan/components/switch.dart' as components;

class Editable extends StatefulWidget {
  const Editable({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Editable> {
  /// 表单唯一
  final _formKey = GlobalKey<FormState>();

  /// 发生时间
  DateTime? _happenedAt;

  @override
  Widget build(BuildContext context) {
    /// 分类
    final categories = context
        .select((Category category) => category.categories)
        .map((e) => SelectOption(value: e.id, label: e.name))
        .toList();

    /// 默认账本
    final billing = context.select(
        (UserProfile userProfile) => userProfile.whoAmI?.defaultBilling);

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
                          billing != null
                              ? billing_components.Card(
                                  billing: billing,
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
                            components.Switch(),
                            Row(
                              children: [
                                const Flexible(
                                    fit: FlexFit.tight, child: Text("花了多少：")),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
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
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: Text("发生时间：")),
                                  Expanded(
                                    flex: 3,
                                    child: DatePicker(
                                      dateTime: _happenedAt,
                                      mode: CupertinoDatePickerMode.date,
                                      onChanged: (value) {
                                        setState(() {
                                          _happenedAt = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Flexible(
                                      fit: FlexFit.tight, child: Text("选择分类：")),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: categories.isNotEmpty
                                          ? Picker(options: categories)
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
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
                        padding: const EdgeInsets.only(bottom: 12, top: 20),
                        child: ElevatedButton(
                          onPressed: () {},
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
