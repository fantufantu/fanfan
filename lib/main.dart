import 'package:fanfan/pages/home.dart';
import 'package:fanfan/service/main.dart';
import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/pages/authorization/sign_in.dart';

void main() async {
  // graphql client
  final client = Client();
  // 全局状态
  final userProfile = UserProfile(client.created);
  // 设置状态机
  client.authorize(userProfile);

  // 交换用户信息
  await userProfile.authorize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => userProfile),
    ],
    child: GraphQLProvider(
      client: ValueNotifier(client.created),
      child: const App(),
    ),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) {
                return const Home();
              }),
          GoRoute(
              path: '/authorization',
              builder: (BuildContext context, GoRouterState state) {
                return const SignIn();
              })
        ],
        redirect: (BuildContext context, GoRouterState state) {
          return null;
        },
      ),
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white),
    );
  }
}
