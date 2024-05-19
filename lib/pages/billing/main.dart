import 'package:fanfan/layouts/main.dart';
import 'package:fanfan/layouts/loading_layout.dart';
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
import 'package:fanfan/service/entities/billing/main.dart';
import 'package:fanfan/service/entities/sharing/main.dart' as sharing;

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

  bool get _isBillingNotEmpty {
    return _billing != null;
  }

  /// 当前账本是否被限额
  bool get _isLimitted {
    return _billing?.limitAmount != null && _billing?.limitDuration != null;
  }

  /// 设置默认账本
  _setDefault(bool isDefault) async {
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
        margin: const EdgeInsets.only(right: 8),
      ),
      _Navigation(
        title: '交易',
        isFilled: false,
        margin: const EdgeInsets.only(left: 8),
        onTap: () {
          GoRouter.of(context).pushNamed(
            NamedRoute.Transactions.name,
            pathParameters: {
              "billingId": widget.id.toString(),
            },
          );
        },
      ),
    ];
  }

  /// 页面信息
  Widget _buildBillingContent(BuildContext context) {
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
                  child: InkWell(
                    onTap: e.onTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: e.margin,
                      decoration: BoxDecoration(
                        color: e.isFilled ? Colors.blue : Colors.white,
                        border: Border.all(
                          width: 4,
                          color: Colors.blue,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(99)),
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
                ),
              )
              .toList(),
        ),
        const Divider(height: 32),
        components.Card(
          billing: _billing!,
          elevation: 0,
        ),
        const Divider(height: 32),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding:
              const EdgeInsets.only(left: 28, right: 28, top: 20, bottom: 20),
          child: Column(
            children: [
              Row(
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
                    onChanged: (value) => _setDefault(value),
                  )
                ],
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "账本共享：",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: _share,
                    icon: const Icon(
                        CupertinoIcons.arrowshape_turn_up_right_fill),
                    label: const Text(
                      "去分享",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const Divider(height: 32),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(28),
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
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.only(left: 12, right: 12),
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).pushNamed(
                        NamedRoute.BillingLimitSettings.name,
                        pathParameters: {
                          "id": _billing!.id.toString(),
                        },
                        queryParameters: {
                          "limitAmount": _billing!.limitAmount?.toString(),
                          "limitDuration": _billing!.limitDuration?.name,
                        },
                      );
                    },
                    icon: const Icon(
                      CupertinoIcons.pencil_outline,
                      size: 14,
                    ),
                    label: const Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _isLimitted
                    ? [
                        Text(
                            "每${LimitDurationDescriptions[_billing!.limitDuration!]}交易限额"),
                        Text('￥${_billing!.limitAmount.toString()}'),
                      ]
                    : [const Text("暂未设置限额！")],
              )
            ],
          ),
        )
      ],
    );
  }

  /// 分享账本
  void _share() {
    GoRouter.of(context).pushNamed(
      NamedRoute.Share.name,
      pathParameters: {
        "type": sharing.Type.Billing.name,
        "target": _billing!.id.toString(),
      },
    );
  }

  /// 记一笔
  void _booking() {
    GoRouter.of(context).pushNamed(
      NamedRoute.EditableTransaction.name,
      extra: {
        "billing": _billing,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBillingNotEmpty) {
      return const LoadingLayout();
    }

    return PopLayout(
      backgroundColor: Colors.grey.shade50,
      centerTitle: false,
      floatingActionButton: FloatingActionButton(
        onPressed: _booking,
        child: const Icon(CupertinoIcons.plus),
      ),
      title: _billing?.name != null
          ? Text(
              _billing!.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
                child: Builder(
                  builder: _buildBillingContent,
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Navigation {
  _Navigation({
    required this.title,
    required this.isFilled,
    required this.margin,
    this.onTap,
  });

  String title;
  bool isFilled;
  EdgeInsetsGeometry margin;
  VoidCallback? onTap;
}
