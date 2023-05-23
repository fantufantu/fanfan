import 'package:graphql/client.dart';

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
