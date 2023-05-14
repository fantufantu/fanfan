import 'package:fanfan/components/switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class SwitchFormField extends FormField<int> {
  SwitchFormField({
    super.key,
    super.initialValue = 0,
    super.onSaved,
    super.autovalidateMode,
    super.enabled,
    super.restorationId,
    super.validator,
    ValueChanged<int>? onChanged,
    required Tuple2<String, String> children,
  }) : super(
          builder: (field) {
            return Switch(
              children: children,
              value: initialValue as int,
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
            );
          },
        );
}
