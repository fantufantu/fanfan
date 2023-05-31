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

    /// 选项
    required List<SelectOption<T>> options,

    /// placeholder
    String? placeholder,
  }) : super(
          builder: (field) {
            return Picker(
              value: field.value,
              options: options,
              onChanged: (value) {
                field.didChange(value);
              },
              placeholder: placeholder,
            );
          },
        );
}
