import 'package:fanfan/service/entities/transaction/editable.dart';
import 'package:fanfan/service/entities/transaction/main.dart';
import 'package:fanfan/service/entities/transaction/paginated_transactions.dart';
import 'package:fanfan/service/schemas/transaction.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<Transaction> createTransaction({
  required Editable editable,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: CREATE_TRANSACTION,
    variables: Map.from(
      {
        "createBy": editable.toJson(),
      },
    ),
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '创建失败！')));
  }

  return Transaction.fromJson(response.data!['createTransaction']);
}

Future<PaginatedTransactions> queryTransaction({
  required int billingId,
  required String direction,
}) async {
  final response = await Client().query(
    QueryOptions(
      document: TRANSACTIONS,
      variables: {
        "filterBy": {
          "billingId": billingId,
          "directions": [direction],
        },
      },
    ),
  );

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return PaginatedTransactions.fromJson(response.data!['transactions']);
}
