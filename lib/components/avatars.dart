import 'package:flutter/material.dart';

class Avatars extends StatelessWidget {
  final double _size = 20;
  final double _borderWidth = 3;

  /// 限制展示个数
  final int limit;

  /// 头像列表
  final List<String> avatars;

  Avatars({
    super.key,
    required this.avatars,
    required this.limit,
  }) {
    assert(avatars.length >= limit);
  }

  /// 计算偏移量
  _calculatedOffset(int index) {
    if (index >= limit) {
      return null;
    }
    return (limit - index) * (_size + _borderWidth);
  }

  /// 按限制条目展示头像
  List<String> get _avatars {
    final limited = avatars.sublist(0, limit).reversed.toList();
    final hasMore = avatars.length > limit;

    // 传入的头像大于限制长度时，拼接一个省略头像长度
    if (hasMore) {
      limited.insert(0, '');
    }
    return limited;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size * (limit + 2) + _borderWidth * (limit + 2),
      child: Stack(
        children: (_avatars
            .asMap()
            .entries
            .map(
              (item) => Positioned(
                left: _calculatedOffset(item.key),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: _borderWidth,
                    ),
                    borderRadius: BorderRadius.circular(_size + _borderWidth),
                  ),
                  child: CircleAvatar(
                    backgroundImage: const AssetImage('images/user/preset.png'),
                    radius: _size,
                  ),
                ),
              ),
            )
            .toList()),
      ),
    );
  }
}
