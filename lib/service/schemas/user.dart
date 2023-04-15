// ignore_for_file: non_constant_identifier_names
import 'package:graphql_flutter/graphql_flutter.dart';

class WhoAmI {
  late int id;
  late String username;
  late String emailAddress;
  String? avatar;
}

final WHO_AM_I = gql('''
  query WhoAmI {
    whoAmI {
      id
      username
      emailAddress
      avatar
      defaultBilling {
        id
        name
      }
    }
  }
''');
