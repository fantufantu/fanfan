import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Picker<T> extends StatefulWidget {
  final ValueChanged<T>? onChanged;

  final List<SelectOption<T>> options;

  final double itemExtent;

  const Picker({
    super.key,
    required this.options,
    this.itemExtent = 48,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _State<T>();
}

class _State<T> extends State<Picker<T>> {
  /// 焦点
  final FocusNode _focusNode = FocusNode();

  /// 选择结果下标
  List<int> _selected = [];

  @override
  initState() {
    super.initState();

    // 监听聚焦节点
    _focusNode.addListener(_onFocusChanged);

    // 初始化默认值
    _initialSelectedItems(widget.options, _selected);
  }

  /// 计算默认的选中项
  _initialSelectedItems(List<SelectOption>? options, List<int> selected) {
    if (options == null || options.isEmpty) return;
    _initialSelectedItems(options.elementAt(0).children, selected..add(0));
  }

  /// 选中选项后的回调
  _onSelectedItemChanged(int cascade, int index, StateSetter setState) {
    final changedSelected = _selected.sublist(0, cascade)..add(index);
    final children = changedSelected.fold<List<SelectOption<T>>?>(
        widget.options,
        (parents, element) => parents?.elementAt(element).children);

    // 子项的默认值
    _initialSelectedItems(children, changedSelected);

    // 更改状态值
    setState(() {
      _selected = changedSelected;
    });
  }

  /// 转换下拉选项
  List<List<_SelectOptionWithoutChildren<T>>> get _options {
    return _selected
        .asMap()
        .entries
        .fold<
            List<
                Tuple2<List<_SelectOptionWithoutChildren<T>>,
                    List<SelectOption<T>>?>>>([], (prev, element) {
          final cascade = element.key;
          final index = element.value;

          final currentCascadeOptions = (cascade == 0
                  ? widget.options
                  : prev.elementAt(cascade - 1).item2) ??
              [];

          // 无下拉层级，不展现
          if (currentCascadeOptions.isEmpty) {
            return prev;
          }

          return prev
            ..add(Tuple2(
                currentCascadeOptions
                    .map((e) => _SelectOptionWithoutChildren(
                        value: e.value, label: e.label))
                    .toList(),
                currentCascadeOptions.elementAt(index).children));
        })
        .map((e) => e.item1)
        .toList();
  }

  /// 选择结果下标转换为选择项
  List<_SelectOptionWithoutChildren> get _selectedOptions => _selected
      .asMap()
      .entries
      .map((e) => _options.elementAt(e.key).elementAt(e.value))
      .toList();

  /// 点击事件
  _open(BuildContext context) {
    // 焦点置于输入框
    _focusNode.requestFocus();

    // 唤起底部抽屉
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
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
                            widget.onChanged?.call(
                              _selectedOptions.last.value,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('确定')),
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: _options
                          .asMap()
                          .entries
                          .map(
                            (e) => Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: CupertinoPicker(
                                  itemExtent: widget.itemExtent,
                                  onSelectedItemChanged: (index) =>
                                      _onSelectedItemChanged(
                                          e.key, index, setState),
                                  children: e.value
                                      .map(
                                        (e) => Center(
                                          child: Text(
                                            e.label,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
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
        child: Text(_selectedOptions.last.label),
      ),
    );
  }
}

class SelectOption<T> extends _SelectOptionWithoutChildren<T> {
  List<SelectOption<T>>? children;

  SelectOption({
    required super.value,
    required super.label,
    this.children,
  });
}

class _SelectOptionWithoutChildren<T> {
  T value;

  String label;

  _SelectOptionWithoutChildren({
    required this.value,
    required this.label,
  });
}
