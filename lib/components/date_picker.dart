import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  /// 初始值
  late final DateTime _initialDateTime;

  /// 值变更回调函数
  final ValueChanged<DateTime>? onChanged;

  DatePicker({
    super.key,
    initialDateTime,
    this.onChanged,
  }) {
    _initialDateTime = initialDateTime ?? DateTime.now();
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
    _selectedDateTime = widget._initialDateTime;
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: _focusNode,
      onTap: () => _open(context),
      child: InputDecorator(
        isFocused: _focusNode.hasFocus,
        decoration: const InputDecoration()
            .applyDefaults(Theme.of(context).inputDecorationTheme),
        child: Text(_selectedDateTime.toString()),
      ),
    );
  }
}
