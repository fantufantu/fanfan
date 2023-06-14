import 'package:fanfan/pages/authorization/main.dart';
import 'package:fanfan/pages/billings.dart';
import 'package:fanfan/pages/home.dart';
import 'package:fanfan/layouts/main.dart' show NavigationLayout;
import 'package:fanfan/pages/loading.dart';
import 'package:fanfan/pages/profile.dart';
import 'package:fanfan/pages/statistics.dart';
import 'package:fanfan/pages/transactions.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/service/entities/billing/main.dart' show LimitDuration;
import 'package:fanfan/store/application.dart';
import 'package:fanfan/store/category.dart';
import 'package:fanfan/utils/application.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/pages/authorization/sign_in.dart';
import 'package:fanfan/pages/authorization/sign_up.dart';
import 'package:fanfan/pages/billing/main.dart' as billing;
import 'package:fanfan/pages/transaction/editable.dart' as transaction;
import 'package:fanfan/pages/share.dart' as sharing;
import 'package:fanfan/pages/transaction/main.dart' as transaction;
import 'package:fanfan/service/entities/sharing/main.dart' as sharing_entities
    show Type;

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfile()),
        ChangeNotifierProvider(create: (_) => Application()),
        ChangeNotifierProvider(create: (_) => Category()),
      ],
      child: const App(),
    ),
  );

  // 应用初始化
  await initialize().whenComplete(() {
    // 应用层逻辑
    final application = Application();
    // 应用初始化完成
    application.ready();
  });
}

class App extends StatelessWidget {
  const App({super.key});

  /// 路由
  List<RouteBase> _buildRoutes(BuildContext context) {
    final isReady =
        context.select((Application application) => application.isReady);

    // 应用未初始化完成时，返回一个loading页
    if (!isReady) {
      return [
        GoRoute(
          path: '/',
          builder: (context, state) => const Loading(),
        )
      ];
    }

    return [
      GoRoute(
        path: "/statistics",
        name: NamedRoute.Statistics.name,
        pageBuilder: (context, state) =>
            const MaterialPage(child: Statistics()),
      ),
      GoRoute(
        path: '/profile',
        name: NamedRoute.Profile.name,
        pageBuilder: (context, state) => const MaterialPage(child: Profile()),
      ),
      GoRoute(
        path: '/billings',
        name: NamedRoute.Billings.name,
        pageBuilder: (context, state) => const MaterialPage(child: Billings()),
      ),
      GoRoute(
        path: '/',
        name: NamedRoute.Home.name,
        pageBuilder: (context, state) => MaterialPage(
          child: NavigationLayout(
            child: const Home(),
          ),
        ),
      ),
      GoRoute(
        path: '/authorization',
        name: NamedRoute.Authorization.name,
        builder: (context, staet) {
          return const Authorization();
        },
        routes: [
          GoRoute(
            path: 'sign-in',
            name: NamedRoute.SignIn.name,
            builder: (context, state) {
              return const SignIn();
            },
          ),
          GoRoute(
            path: 'sign-up',
            name: NamedRoute.SignUp.name,
            builder: (context, state) {
              return const SignUp();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/billing/editable',
        name: NamedRoute.EditableBilling.name,
        builder: (context, state) {
          return const billing.Editable();
        },
      ),
      GoRoute(
        path: '/billing/:id',
        name: NamedRoute.Billing.name,
        builder: (context, state) {
          return billing.Billing(
            id: int.parse(state.pathParameters['id']!),
          );
        },
        routes: [
          GoRoute(
              path: 'limit-settings',
              name: NamedRoute.BillingLimitSettings.name,
              builder: (context, state) {
                return billing.LimitSettings(
                  id: int.parse(state.pathParameters['id']!),
                  initialLimitAmount: double.tryParse(
                      state.queryParameters['limitAmount'] ?? ''),
                  initialLimitDuration: LimitDuration.values
                      .asNameMap()[state.queryParameters['limitDuration']],
                );
              })
        ],
      ),
      GoRoute(
        path: '/transactions/:billingId',
        name: NamedRoute.Transactions.name,
        builder: (context, state) {
          return Transactions(
            billingId: int.parse(state.pathParameters['billingId']!),
          );
        },
      ),
      GoRoute(
        path: '/transaction/editable',
        name: NamedRoute.EditableTransaction.name,
        builder: (context, state) {
          return transaction.Editable(
            billing: (state.extra as Map<String, dynamic>?)?['billing'],
          );
        },
      ),
      GoRoute(
        path: '/share/:type/:target',
        name: NamedRoute.Share.name,
        builder: (context, state) {
          return sharing.Share(
            target: int.parse(state.pathParameters['target']!),
            type: sharing_entities.Type.values
                .asNameMap()[state.pathParameters['type']]!,
          );
        },
      ),
      GoRoute(
        path: '/transaction/:id',
        name: NamedRoute.Transaction.name,
        builder: (context, state) {
          return transaction.Transaction(
            id: int.parse(state.pathParameters['id']!),
          );
        },
      ),
    ];
  }

  @override
  Widget build(context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: _buildRoutes(context),
      ),
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          focusColor: Colors.deepOrange,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide.none,
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: const TextStyle(
            fontSize: 14,
          ),
        ),
        checkboxTheme: const CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          side: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
