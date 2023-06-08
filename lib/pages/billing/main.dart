import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/api/billing.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fanfan/service/entities/billing/main.dart' as entities
    show Billing;
import 'package:fanfan/components/billing/card.dart' as components show Card;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

export './editable.dart';
export './limit_settings.dart';

class Billing extends StatefulWidget {
  final int id;

  const Billing({
    super.key,
    required this.id,
  });

  @override
  State<Billing> createState() => _State();
}

class _State extends State<Billing> {
  /// 账本信息
  entities.Billing? _billing;

  @override
  void initState() {
    super.initState();

    (() async {
      final billing = (await queryBilling(widget.id));

      setState(() {
        _billing = billing;
      });
    })();
  }

  get _isBillingNotEmpty {
    return _billing != null;
  }

  /// 设置默认账本
  _setDefault(bool isDefault, {required BuildContext context}) async {
    final isSucceed = await setDefault(id: _billing!.id, isDefault: isDefault);
    if (!isSucceed) return;
    await context.read<UserProfile>().refreshDefaultBilling();
  }

  /// 导航的信息
  List<_Navigation> get _navigations {
    return [
      _Navigation(
        title: '明细',
        isFilled: true,
      ),
      _Navigation(title: '交易', isFilled: false),
    ];
  }

  /// 页面信息
  _buildBillingContent() {
    if (!_isBillingNotEmpty) {
      return const Text("获取账本失败！");
    }

    final isDefault = context.select((UserProfile userProfile) {
      return userProfile.whoAmI?.defaultBilling?.id == _billing?.id;
    });

    return Column(
      children: [
        // 顶部按钮导航
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _navigations
              .map(
                (e) => Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: e.isFilled ? Colors.blue : Colors.white,
                      border: Border.all(
                        width: 4,
                        color: Colors.blue,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(99)),
                    ),
                    child: Text(
                      e.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: e.isFilled ? Colors.white : Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Divider(),
        components.Card(
          billing: _billing!,
          elevation: 0,
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "设置默认：",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: isDefault,
                onChanged: (value) => _setDefault(value, context: context),
              )
            ],
          ),
        ),
        const Divider(),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "限额设置",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(
                          NamedRoute.BillingLimitSettings.name,
                          pathParameters: {
                            "id": _billing!.id.toString(),
                          });
                    },
                    icon: const Icon(
                      CupertinoIcons.pencil_ellipsis_rectangle,
                      size: 14,
                    ),
                    label: const Text("修改"),
                  )
                ],
              ),
              const Divider(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("data"),
                  Text("data"),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopLayout(
      backgroundColor: Colors.grey.shade50,
      child: _buildBillingContent(),
      title: _billing?.name != null
          ? Text(
              _billing!.name,
              style: const TextStyle(
                color: Colors.black,
              ),
            )
          : null,
    );
  }
}

class _Navigation {
  _Navigation({
    required this.title,
    required this.isFilled,
  });

  String title;
  bool isFilled;
}
