import 'package:fanfan/service/factories/entity.dart';
import 'package:fanfan/service/entities/direction.dart';

class Category implements Entity {
  Category({
    required this.id,
    required this.name,
    required this.direction,
  });

  /// 分类id
  int id;

  /// 分类名称
  String name;

  /// 交易方向
  Direction direction;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        direction: Direction.values.asNameMap()[json['direction']]!,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "direction": direction.name,
      };
}
