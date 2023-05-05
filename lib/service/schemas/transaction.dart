import 'package:graphql/client.dart';

final CREATE_TRANSACTION = gql('''
  mutation CreateBilling(\$createBillingBy: CreateBillingBy!) {
    createBilling(createBillingBy: \$createBillingBy) {
      id
    }
  }
''');
