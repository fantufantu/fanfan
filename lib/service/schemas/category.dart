import 'package:graphql_flutter/graphql_flutter.dart';

final CATEGORIES = gql('''
  query Categories {
    categories {
      items {
        id
        name
        icon
      }
    }
  }
''');
