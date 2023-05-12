import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 受控组件
class DatePicker extends StatefulWidget {
  /// 初始值
  late final DateTime _dateTime;

  /// 值变更回调函数
  final ValueChanged<DateTime>? onChanged;

  /// 日历模式
  final CupertinoDatePickerMode mode;

  /// 日历顺序
  final DatePickerDateOrder dateOrder;

  DatePicker({
    super.key,
    dateTime,
    this.onChanged,
    this.mode = CupertinoDatePickerMode.dateAndTime,
    this.dateOrder = DatePickerDateOrder.ymd,
  }) {
    _dateTime = dateTime ?? DateTime.now();
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State<T> extends State<DatePicker> {
  /// 焦点
  final FocusNode _focusNode = FocusNode();

  /// 选中时间
  late DateTime _selectedDateTime;

  /// 初始化状态
  @override
  initState() {
    super.initState();
    _selectedDateTime = widget._dateTime;
  }

  /// 打开选择器
  _open(BuildContext context) {
    // 焦点置于输入框
    _focusNode.requestFocus();

    /// 打开底部选择器
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('取消')),
                          TextButton(
                              onPressed: () {
                                widget.onChanged?.call(_selectedDateTime);
                                Navigator.pop(context);
                              },
                              child: const Text('确定')),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    Flexible(
                      child: CupertinoDatePicker(
                        initialDateTime: _selectedDateTime,
                        mode: widget.mode,
                        dateOrder: widget.dateOrder,
                        onDateTimeChanged: (value) {
                          setState(() {
                            _selectedDateTime = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  String get formattedDateTime {
    return '${widget._dateTime.year}-${widget._dateTime.month}-${widget._dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: _focusNode,
      onTap: () => _open(context),
      child: InputDecorator(
        isFocused: _focusNode.hasFocus,
        decoration: const InputDecoration()
            .applyDefaults(Theme.of(context).inputDecorationTheme),
        child: Text(
          formattedDateTime,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
