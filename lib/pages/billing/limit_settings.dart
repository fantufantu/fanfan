import 'package:fanfan/components/form/picker_form_field.dart';
import 'package:fanfan/components/picker.dart';
import 'package:fanfan/layouts/main.dart';
import 'package:flutter/material.dart';

enum _Duration {
  day,
  weak,
  month,
  year,
}

class LimitSettings extends StatefulWidget {
  final int id;

  const LimitSettings({
    super.key,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LimitSettings> {
  final _durationOptions = [
    SelectOption(label: "天", value: _Duration.day),
    SelectOption(label: "周", value: _Duration.weak),
    SelectOption(label: "月", value: _Duration.month),
    SelectOption(label: "年", value: _Duration.year),
  ];

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
                      initialValue: 0,
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
                    child: TextFormField(),
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
                onPressed: () {},
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
