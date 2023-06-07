import 'package:fanfan/service/entities/billing/main.dart';
import 'package:fanfan/service/factories/entity.dart';

class WhoAmI implements Entity {
  WhoAmI({
    required this.id,
    required this.username,
    required this.emailAddress,
    this.avatar,
    this.defaultBilling,
  });

  /// 用户id
  int id;

  /// 用户名
  String username;

  /// 邮箱地址
  String emailAddress;

  /// 头像地址
  String? avatar;

  /// 默认账本
  Billing? defaultBilling;

  factory WhoAmI.fromJson(Map<String, dynamic> json) => WhoAmI(
        id: json["id"],
        username: json["username"],
        emailAddress: json["emailAddress"],
        avatar: json["avatar"],
        defaultBilling: json['defaultBilling'] == null
            ? null
            : Billing.fromJson(json['defaultBilling']),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "emailAddress": emailAddress,
        "avatar": avatar,
        "defaultBilling": defaultBilling?.toJson(),
      };

  /// 用户名简称
  String get nickname {
    if (RegExp(r"^[a-f\d]{4}(?:[a-f\d]{4}-){4}[a-f\d]{12}$")
        .hasMatch(username)) {
      return '用户 ${username.substring(0, 4)}';
    } else {
      return username;
    }
  }
}
