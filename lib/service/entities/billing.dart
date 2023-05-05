import 'package:fanfan/service/entities/who_am_i.dart';

class Billing {
  Billing({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
  });

  /// 账本id
  int id;

  /// 账本名称
  String name;

  /// 账本创建人
  WhoAmI createdBy;

  /// 创建时间
  DateTime createdAt;

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        id: json["id"],
        name: json['name'],
        createdBy: WhoAmI.fromJson(json['createdBy']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdBy": createdBy.toJson(),
        "createdAt": createdAt.toString(),
      };
}
