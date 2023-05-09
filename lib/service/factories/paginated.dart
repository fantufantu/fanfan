import 'package:fanfan/service/factories/entity.dart';

abstract class Paginated<T extends Entity> {
  Paginated({
    this.total,
    required this.items,
  });

  /// 总条目数
  int? total;

  /// 条目
  List<T> items;

  Map<String, dynamic> toJson() => {
        "total": total,
        "items": items.map((item) => item.toJson()).toList(),
      };
}
