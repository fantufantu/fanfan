import 'package:graphql/client.dart';

final CREATE_TRANSACTION = gql('''
  mutation CreateTransaction(\$createBy: CreateTransactionBy!) {
    createTransaction(createTransactionBy: \$createBy) {
      id
    }
  }
''');
