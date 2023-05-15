import 'package:fanfan/components/picker.dart';
import 'package:flutter/cupertino.dart';

class PickerFormField<T> extends FormField<int> {
  PickerFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    super.autovalidateMode,
    super.enabled,
    super.restorationId,
    super.validator,

    /// 属性传递
    required List<SelectOption<T>> options,
  }) : super(
          builder: (field) {
            return Picker(
              value: field.value,
              options: options,
              onChanged: (value) {
                field.didChange(value);
              },
            );
          },
        );
}
