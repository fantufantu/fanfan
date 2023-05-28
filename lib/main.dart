import 'package:fanfan/pages/authorization/main.dart';
import 'package:fanfan/pages/billings.dart';
import 'package:fanfan/pages/home.dart';
import 'package:fanfan/layouts/main.dart' show NavigationLayout, PopLayout;
import 'package:fanfan/pages/loading.dart';
import 'package:fanfan/pages/profile.dart';
import 'package:fanfan/pages/statistics.dart';
import 'package:fanfan/pages/transactions.dart';
import 'package:fanfan/router/main.dart';
import 'package:fanfan/store/application.dart';
import 'package:fanfan/store/category.dart';
import 'package:fanfan/utils/application.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/pages/authorization/sign_in.dart';
import 'package:fanfan/pages/authorization/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanfan/pages/billing/main.dart' as billing;
import 'package:fanfan/pages/transaction/editable.dart' as transaction;

void main() async {
  // 禁用http请求获取远程字体
  GoogleFonts.config.allowRuntimeFetching = false;

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
  await initialize();
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
          builder: (context, state) => Loading(),
        )
      ];
    }

    return [
      GoRoute(
        path: "/statistics",
        name: NamedRoute.Statistics.name,
        pageBuilder: (context, state) =>
            MaterialPage(child: NavigationLayout(child: const Statistics())),
      ),
      GoRoute(
        path: '/profile',
        name: NamedRoute.Profile.name,
        pageBuilder: (context, state) => const MaterialPage(child: Profile()),
      ),
      GoRoute(
        path: '/billings',
        name: NamedRoute.Billings.name,
        pageBuilder: (context, state) => MaterialPage(child: const Billings()),
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
        pageBuilder: (context, staet) =>
            const MaterialPage(child: Authorization()),
        routes: [
          GoRoute(
            path: 'sign-in',
            name: NamedRoute.SignIn.name,
            pageBuilder: (context, staet) =>
                const MaterialPage(child: SignIn()),
          ),
          GoRoute(
            path: 'sign-up',
            name: NamedRoute.SignUp.name,
            pageBuilder: (context, staet) =>
                const MaterialPage(child: SignUp()),
          ),
        ],
      ),
      GoRoute(
        path: '/billing/editable',
        name: NamedRoute.EditableBilling.name,
        pageBuilder: (context, state) =>
            const MaterialPage(child: PopLayout(child: billing.Editable())),
      ),
      GoRoute(
        path: '/billing/:id',
        name: NamedRoute.Billing.name,
        builder: (context, state) => billing.Billing(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/transactions',
        name: NamedRoute.Transactions.name,
        pageBuilder: (context, state) =>
            const MaterialPage(child: Transactions()),
      ),
      GoRoute(
        path: '/transaction/editable',
        name: NamedRoute.EditableTransaction.name,
        pageBuilder: (context, state) =>
            const MaterialPage(child: transaction.Editable()),
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
          textTheme: GoogleFonts.josefinSansTextTheme(),
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
          )),
    );
  }
}
