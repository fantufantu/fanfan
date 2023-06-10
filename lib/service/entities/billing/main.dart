import 'package:fanfan/service/entities/who_am_i.dart';
import 'package:fanfan/service/factories/entity.dart';

enum LimitDuration {
  Day,
  Week,
  Month,
  Year,
}

final LimitDurationDescriptions = Map.from({
  LimitDuration.Day: "日",
  LimitDuration.Week: "周",
  LimitDuration.Month: "月",
  LimitDuration.Year: "年",
});

class Billing extends Entity {
  Billing({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    this.limitAmount,
    this.limitDuration,
  });

  /// 账本id
  int id;

  /// 账本名称
  String name;

  /// 账本创建人
  WhoAmI createdBy;

  /// 创建时间
  DateTime createdAt;

  /// 限额时间段
  LimitDuration? limitDuration;

  /// 限制金额
  double? limitAmount;

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        id: json["id"],
        name: json['name'],
        createdBy: WhoAmI.fromJson(json['createdBy']),
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        limitAmount: double.tryParse(json['limitAmount'].toString()),
        limitDuration: LimitDuration.values.asNameMap()[json['limitDuration']],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdBy": createdBy.toJson(),
        "createdAt": createdAt.toString(),
        "limitAmount": limitAmount,
        "limitDuration": limitDuration?.name,
      };
}
