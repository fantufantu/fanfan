// ignore_for_file: non_constant_identifier_names
import 'package:graphql_flutter/graphql_flutter.dart';

class RegisterBy {
  late String emailAddress;
  late String captcha;
  late String password;
}

final REGISTER = gql('''
  mutation Register(\$registerBy: RegisterBy!) {
    register(registerBy: \$registerBy)
  }
''');
