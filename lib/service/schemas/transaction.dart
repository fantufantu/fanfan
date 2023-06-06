import 'package:graphql/client.dart';

final CREATE_TRANSACTION = gql('''
  mutation CreateTransaction(\$createBy: CreateTransactionBy!) {
    createTransaction(createBy: \$createBy) {
      id
    }
  }
''');

final TRANSACTIONS = gql(r'''
  query Transactions($filterBy: FilterTransactionBy!) {
    transactions(filterBy: $filterBy) {
      items {
        id
        amount
        remark
        billingId
        happenedAt
        category {
          id
          name
          icon
          direction
        }
      }
    }
  }
''');
