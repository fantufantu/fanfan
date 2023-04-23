import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/service/schemas/billing.dart';
import 'package:fanfan/utils/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Future<List<Billing>> queryBillings() async {
  final response = await Client().query(
    QueryOptions(
      document: BILLINGS,
    ),
  );

  if (response.hasException || response.data == null) {
    throw response.exception?.graphqlErrors.single ??
        const GraphQLError(message: '获取账本失败');
  }

  return [];
}
