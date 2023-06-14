import 'package:fanfan/service/entities/user.dart';
import 'package:fanfan/service/schemas/user.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql/client.dart';

/// 利用用户关键字查询用户列表
Future<List<User>> queryUsers(String who) async {
  final response = await Client().query(
    QueryOptions(
      document: USERS,
      variables: {
        "who": who,
      },
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return (response.data!['users'] as List<dynamic>)
      .map((e) => User.fromJson(e))
      .toList();
}
