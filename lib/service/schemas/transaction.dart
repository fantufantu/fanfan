import 'package:graphql_flutter/graphql_flutter.dart';

final CREATE_TRANSACTION = gql('''
  mutation CreateTransaction(\$createBy: CreateTransactionBy!) {
    createTransaction(createBy: \$createBy) {
      id
    }
  }
''');

final TRANSACTIONS = gql('''
  query Transactions(\$filterBy: FilterTransactionBy!) {
    transactions(filterBy: \$filterBy) {
      items {
        id
        amount
        remark
        billingId
        categoryId
        happenedAt
        direction
      }
    }
  }
''');
