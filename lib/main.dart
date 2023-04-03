import 'package:fanfan/pages/authorization/how_to_authorize.dart';
import 'package:fanfan/pages/authorization/main.dart';
import 'package:fanfan/pages/home.dart';
import 'package:fanfan/service/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/pages/authorization/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // graphql client
  final client = Client();
  // 全局状态
  final userProfile = UserProfile(client.created);
  // 设置状态机
  client.setUserProfile(userProfile);

  // 禁用http请求获取远程字体
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => userProfile),
    ],
    child: GraphQLProvider(
      client: ValueNotifier(client.created),
      child: const App(),
    ),
  ));

  // 交换用户信息
  userProfile.authorize();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/authorization',
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) {
                return const Home();
              }),
          ShellRoute(
            builder: (context, state, child) {
              return Authorization(child: child);
            },
            routes: [
              GoRoute(
                path: '/authorization',
                builder: (context, staet) {
                  return const HowToAuthorize();
                },
                routes: [
                  GoRoute(
                    path: 'sign-in',
                    builder: (context, state) {
                      return const SignIn();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        redirect: (context, state) {
          return null;
        },
      ),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.josefinSansTextTheme(),
      ),
    );
  }
}
