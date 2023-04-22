import 'package:fanfan/service/schemas/authorization.dart';
import 'package:fanfan/utils/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum VerificationType { Email, Phone }

class Authorization {
  /// 注册
  static Future<String> register({
    required String emailAddress,
    required String captcha,
    required String password,
  }) async {
    final response = await Client().mutate(
      MutationOptions(
        document: REGISTER,
        variables: Map.from(
          {
            "registerBy": Map.from(
              {
                "emailAddress": emailAddress,
                "captcha": captcha,
                "password": password,
              },
            ),
          },
        ),
      ),
    );

    if (response.hasException || response.data == null) {
      throw response.exception?.graphqlErrors.single ??
          const GraphQLError(message: '注册失败，请稍后重试！');
    }

    return response.data!['register'];
  }

  /// 发送验证码
  static Future<DateTime> sendCaptcha(
      {required String to, required String type}) async {
    final response = await Client().mutate(
      MutationOptions(
        document: SEND_CAPTCHA,
        variables: Map.from(
          {
            "sendCaptchaBy": Map.from(
              {
                "to": to,
                "type": type,
              },
            ),
          },
        ),
      ),
    );

    if (response.hasException || response.data == null) {
      throw response.exception?.graphqlErrors.single ??
          const GraphQLError(message: '发送验证码异常，请稍后重试！');
    }

    return DateTime.parse(response.data!['sendCaptcha']);
  }

  /// 登录
  static Future<String> login(
      {required String who, required String password}) async {
    final response = await Client().mutate(
      MutationOptions(
        document: LOGIN,
        variables: Map.from(
          {
            "loginBy": Map.from(
              {
                "who": who,
                "password": password,
              },
            ),
          },
        ),
      ),
    );

    if (response.hasException || response.data == null) {
      throw response.exception?.graphqlErrors.single ??
          const GraphQLError(message: '登录失败，请稍后重试！');
    }

    return response.data!['login'];
  }
}