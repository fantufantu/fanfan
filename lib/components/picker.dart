import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker<T> extends StatefulWidget {
  /// 用户选择item之后的回调函数
  final ValueChanged<int>? onChanged;

  /// 预置选项，提供给用户选择用
  final List<SelectOption<T>> options;

  /// item的渲染高度
  final double itemExtent;

  /// 默认选中下标
  final int? value;

  /// placeholder
  final String? placeholder;

  const Picker({
    super.key,
    required this.options,
    this.itemExtent = 48,
    this.onChanged,
    this.value,
    this.placeholder,
  });

  @override
  State<StatefulWidget> createState() => _State<T>();
}

class _State<T> extends State<Picker<T>> {
  /// 焦点
  final FocusNode _focusNode = FocusNode();

  /// 选中的选项
  int? _selectedItem;

  @override
  initState() {
    super.initState();

    // 监听聚焦节点
    _focusNode.addListener(_onFocusChanged);
    // 初始化默认选中值
    _selectedItem = widget.value;
  }

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 保证组件受控
    _selectedItem = widget.value;
  }

  /// 点击事件
  _open(BuildContext context) {
    // 焦点置于输入框
    _focusNode.requestFocus();
    // 生成一个滚动控制器
    final scrollController =
        FixedExtentScrollController(initialItem: widget.value ?? 0);

    // 唤起底部抽屉
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: widget.itemExtent * 6,
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
                          // 更新状态
                          setState(() {
                            _selectedItem = scrollController.selectedItem;
                          });
                          // 回调函数
                          widget.onChanged?.call(scrollController.selectedItem);
                          Navigator.pop(context);
                        },
                        child: const Text('确定')),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: CupertinoPicker(
                    itemExtent: widget.itemExtent,
                    onSelectedItemChanged: null,
                    scrollController: scrollController,
                    children: widget.options
                        .map(
                          (option) => Center(
                            child: Text(
                              option.label,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFocusChanged() {
    setState(() {});
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
        child: _selectedItem != null
            ? Text(
                widget.options.elementAt(_selectedItem!).label,
              )
            : widget.placeholder != null
                ? Text(
                    widget.placeholder!,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  )
                : null,
      ),
    );
  }
}

class SelectOption<T> {
  T value;

  String label;

  SelectOption({
    required this.value,
    required this.label,
  });
}
