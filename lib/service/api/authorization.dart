import 'package:fanfan/service/entities/registered.dart';
import 'package:fanfan/service/entities/captcha_sent.dart';
import 'package:fanfan/service/schemas/authorization.dart';
import 'package:fanfan/utils/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum VerificationType { Email, Phone }

class Authorization {
  /// 注册
  static Future<Registered?> register({
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
          )),
    );

    if (response.hasException || response.data == null) {
      throw response.exception?.graphqlErrors.single ??
          const GraphQLError(message: '注册失败，请稍后重试');
    }

    return Registered.fromJson(response.data!);
  }

  /// 发送验证码
  static Future<CaptchaSent?> sendCaptcha(
      {required String to, required String type}) async {
    final response = await Client().mutate(
      MutationOptions(
        document: SEND_CAPTCHA,
        variables: Map.from({
          "sendCaptchaBy": Map.from(
            {
              "to": to,
              "type": type,
            },
          ),
        }),
      ),
    );

    if (response.hasException || response.data == null) {
      throw response.exception?.graphqlErrors.single ??
          const GraphQLError(message: '发送验证码异常，请稍后重试');
    }

    return CaptchaSent.fromJson(response.data!);
  }
}
