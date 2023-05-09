import 'package:fanfan/service/api/billing.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fanfan/service/entities/billing.dart' as entities;
import 'package:fanfan/components/billing/card.dart' as components;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

export './editable.dart';

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

  /// 页面信息
  _buildBillingContent(
    BuildContext context, {
    required bool isDefault,
  }) {
    if (!_isBillingNotEmpty) {
      return const Text("获取账本失败！");
    }

    return Column(
      children: [
        components.Card(
          billing: _billing!,
          elevation: 0,
        ),
        const Divider(
          height: 32,
        ),
        SizedBox(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("账本名称"),
                      Text(_billing!.name),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("账本名称"),
                      Text(_billing!.name),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("设置默认："),
            Switch(
              value: isDefault,
              onChanged: (value) => _setDefault(value, context: context),
            )
          ],
        ),
        const Divider(
          height: 40,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.only(top: 8, bottom: 8))),
                  onPressed: () {
                    context.go('/billing/editable');
                  },
                  child: Text("修改账本"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                      padding: const MaterialStatePropertyAll(
                          EdgeInsets.only(top: 8, bottom: 8))),
                  onPressed: () {},
                  child: Text("交易明细"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultBillingId = context.select(
        (UserProfile userProfile) => userProfile.whoAmI?.defaultBilling?.id);
    final isDefault = defaultBillingId == _billing?.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              context.canPop() ? context.pop() : context.go('/');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        title: _isBillingNotEmpty
            ? Text(
                _billing!.name,
                style: TextStyle(
                  color: Colors.black,
                ),
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                ),
              )
            : null,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.gear,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: SafeArea(
          child: _buildBillingContent(context, isDefault: isDefault),
        ),
      ),
    );
  }
}
