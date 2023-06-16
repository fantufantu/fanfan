import 'package:fanfan/components/form/picker_form_field.dart';
import 'package:fanfan/components/picker.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/billing.dart';
import 'package:fanfan/service/entities/billing/main.dart';
import 'package:fanfan/service/entities/billing/limit_settings.dart' as entities
    show LimitSettings;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LimitSettings extends StatefulWidget {
  final int id;
  final double? initialLimitAmount;
  final LimitDuration? initialLimitDuration;

  const LimitSettings({
    super.key,
    required this.id,
    this.initialLimitAmount,
    this.initialLimitDuration,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LimitSettings> {
  /// 表单
  final _formKey = GlobalKey<FormState>();

  /// 下拉选项
  final _durationOptions = LimitDuration.values
      .map((e) =>
          SelectOption(value: e.name, label: LimitDurationDescriptions[e]))
      .toList();

  /// 表单项
  late entities.LimitSettings _limitSettings;

  @override
  void initState() {
    super.initState();

    _limitSettings = entities.LimitSettings(
      limitAmount: widget.initialLimitAmount,
      limitDuration: widget.initialLimitDuration,
    );
  }

  /// 表单提交
  void _submit() async {
    // 触发表单保存
    _formKey.currentState?.save();

    final isSucceed = await setLimit(
      id: widget.id,
      limitSettings: _limitSettings,
    );

    if (!isSucceed) return;

    // 跳转回账本页
    GoRouter.of(context).goNamed(NamedRoute.Billing.name, pathParameters: {
      "id": widget.id.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      centerTitle: false,
      title: const Text(
        "限额设置",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      "限额时间段：",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: PickerFormField(
                      options: _durationOptions,
                      initialValue: _limitSettings.limitDuration != null
                          ? LimitDuration.values
                              .indexOf(_limitSettings.limitDuration!)
                          : null,
                      onSaved: (newValue) {
                        _limitSettings.limitDuration =
                            LimitDuration.values.elementAt(newValue!);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      "限额金额：",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      initialValue: _limitSettings.limitAmount?.toString(),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      onSaved: (value) {
                        _limitSettings.limitAmount = double.tryParse(value!);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入金额';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    padding: const MaterialStatePropertyAll(
                        EdgeInsets.only(top: 16, bottom: 16))),
                onPressed: _submit,
                child: const Text(
                  "保存修改",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
