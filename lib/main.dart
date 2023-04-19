import 'package:fanfan/pages/authorization/how_to_authorize.dart';
import 'package:fanfan/pages/authorization/main.dart';
import 'package:fanfan/pages/home.dart';
import 'package:fanfan/pages/layout.dart';
import 'package:fanfan/pages/profile.dart';
import 'package:fanfan/pages/statistics.dart';
import 'package:fanfan/utils/client.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/pages/authorization/sign_in.dart';
import 'package:fanfan/pages/authorization/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // 禁用http请求获取远程字体
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProfile()),
    ],
    child: GraphQLProvider(
      client: ValueNotifier(
        Client(),
      ),
      child: const App(),
    ),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  /// 路由
  List<RouteBase> _buildRoutes(BuildContext context) {
    // 是否认证
    bool isLoggedIn =
        context.select((UserProfile userProfile) => userProfile.isLoggedIn);

    return [
      ShellRoute(
        builder: (context, state, child) {
          return Layout(child: child);
        },
        routes: [
          GoRoute(
            path: "/statistics",
            pageBuilder: (context, state) => MaterialPage(child: Statistics()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const MaterialPage(child: Profile()),
          ),
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const MaterialPage(child: Home()),
          ),
        ],
      ),
      ...(!isLoggedIn
          ? [
              ShellRoute(
                builder: (context, state, child) => Authorization(child: child),
                routes: [
                  GoRoute(
                    path: '/authorization',
                    pageBuilder: (context, staet) {
                      return const MaterialPage(child: HowToAuthorize());
                    },
                    routes: [
                      GoRoute(
                        path: 'sign-in',
                        pageBuilder: (context, staet) {
                          return const MaterialPage(child: SignIn());
                        },
                      ),
                      GoRoute(
                        path: 'sign-up',
                        pageBuilder: (context, staet) {
                          return const MaterialPage(child: SignUp());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ]
          : []),
    ];
  }

  @override
  Widget build(context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/statistics',
        routes: _buildRoutes(context),
        redirect: (context, state) {
          return null;
        },
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
      ),
    );
  }
}
