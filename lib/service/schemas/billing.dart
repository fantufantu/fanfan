import 'package:graphql_flutter/graphql_flutter.dart';

final BILLINGS = gql('''
  query Billings {
    billings {
      items {
        id
      }
      total
    }
  }
''');
