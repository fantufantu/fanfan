import 'package:fanfan/service/entities/billing/main.dart';
import 'package:fanfan/service/factories/entity.dart';

class LimitSettings extends Entity {
  double? limitAmount;
  LimitDuration? limitDuration;

  LimitSettings({
    this.limitAmount,
    this.limitDuration,
  });

  @override
  Map<String, dynamic> toJson() => {
        "limitAmount": limitAmount,
        "limitDuration": limitDuration?.name,
      };
}
