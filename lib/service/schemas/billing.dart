import 'package:graphql_flutter/graphql_flutter.dart';

final BILLINGS = gql('''
  query Billings {
    billings {
      items {
        id
        name
        createdBy {
          id
          username
          emailAddress
          avatar
        }
        createdAt
      }
      total
    }
  }
''');

final CREATE_BILLING = gql('''
  mutation CreateBilling(\$createBy: CreateBillingBy!) {
    createBilling(createBy: \$createBy) {
      id
    }
  }
''');

final BILLING = gql('''
  query Billing(\$id: Int!) {
    billing(id: \$id) {
      id
      name
      createdBy {
        id
        username
        emailAddress
        avatar
      }
      createdAt
    }
  }
''');

final SET_DEFAULT = gql('''
  mutation SetDefaultBilling(\$setBy: SetDefaultBillingBy!) {
    setDefaultBilling(setBy: \$setBy)
  }
''');
