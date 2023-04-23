import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/service/schemas/billing.dart';
import 'package:fanfan/utils/client.dart';
import 'package:graphql/client.dart';

Future<List<Billing>> queryBillings() async {
  final response = await Client().query(
    QueryOptions(
      document: BILLINGS,
    ),
  );

  if (response.hasException || response.data == null) {
    throw response.exception?.graphqlErrors.single ??
        const GraphQLError(message: '获取账本失败！');
  }

  return [];
}

Future<Billing> createBilling({required String name}) async {
  final response = await Client().mutate(MutationOptions(
    document: CREATE_BILLING,
    variables: Map.from(
      {
        "createBillingBy": Map.from(
          {"name": name},
        )
      },
    ),
  ));

  if (response.hasException || response.data == null) {
    throw response.exception?.graphqlErrors.single ??
        const GraphQLError(message: '创建账本失败！');
  }

  return Billing.fromJson(response.data!['createBilling']);
}
