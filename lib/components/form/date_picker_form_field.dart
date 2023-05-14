import 'package:fanfan/components/date_picker.dart';
import 'package:flutter/cupertino.dart';

class DatePickerFormField extends FormField<DateTime> {
  DatePickerFormField({
    super.key,
    super.initialValue,
    super.onSaved,
    super.autovalidateMode,
    super.enabled,
    super.restorationId,
    super.validator,

    /// 属性传递
    CupertinoDatePickerMode? mode,
    ValueChanged<DateTime>? onChanged,
  }) : super(
          builder: (field) {
            return DatePicker(
              dateTime: field.value,
              mode: mode ?? CupertinoDatePickerMode.date,
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
            );
          },
        );
}
