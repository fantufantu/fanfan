import 'package:graphql_flutter/graphql_flutter.dart';

final REGISTER = gql('''
  mutation Register(\$registerBy: RegisterBy!) {
    register(registerBy: \$registerBy)
  }
''');

final SEND_CAPTCHA = gql('''
  mutation SendCaptcha(\$sendCaptchaBy: SendCaptchaBy!) {
    sendCaptcha(sendCaptchaBy: \$sendCaptchaBy)
  }
''');

final LOGIN = gql('''
  mutation Login(\$loginBy: LoginBy!) {
    login(loginBy: \$loginBy)
  }
''');
