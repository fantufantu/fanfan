import 'package:graphql_flutter/graphql_flutter.dart';

final BILLINGS = gql('''
  mutation Login(\$loginBy: LoginBy!) {
    login(loginBy: \$loginBy)
  }
''');
