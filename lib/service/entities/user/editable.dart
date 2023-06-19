import 'package:fanfan/service/factories/entity.dart';

class Editable extends Entity {
  Editable({
    this.nickname,
  });

  /// 交易归属的账本
  String? nickname;

  @override
  Map<String, dynamic> toJson() => {
        "nickname": nickname,
      };
}
