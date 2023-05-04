import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class BottomSelectSheetButton<T> extends StatefulWidget {
  final ValueChanged<T>? onChanged;

  final List<SelectOption<T>> options;

  const BottomSelectSheetButton({
    super.key,
    required this.options,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() =>
      _BottomSelectSheetButtomButtonState<T>();
}

class _BottomSelectSheetButtomButtonState<T>
    extends State<BottomSelectSheetButton<T>> {
  /// 焦点
  final FocusNode _focusNode = FocusNode();

  /// 下拉结果
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
                    List<SelectOption<T>>?>>>([], (previous, element) {
          final cascade = element.key;
          final index = element.value;

          final currentCascadeOptions = (cascade == 0
                  ? widget.options
                  : previous.elementAt(cascade - 1).item2) ??
              [];

          if (currentCascadeOptions.isEmpty) {
            return previous..add(const Tuple2([], []));
          }

          return previous
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

  /// 点击事件
  _open(BuildContext context) {
    _focusNode.requestFocus();

    // 唤起底部抽屉
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => SafeArea(
                  child: Row(
                    children: _options
                        .asMap()
                        .entries
                        .map(
                          (e) => Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: CupertinoPicker(
                                itemExtent: 48,
                                onSelectedItemChanged: (index) =>
                                    _onSelectedItemChanged(
                                        e.key, index, setState),
                                children: e.value
                                    .map(
                                      (e) => Center(
                                        child: Text(e.label),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )));
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
        decoration: InputDecoration()
            .applyDefaults(Theme.of(context).inputDecorationTheme),
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
