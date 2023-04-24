import 'package:fanfan/service/entities/billing.dart';
import 'package:fanfan/service/entities/paginated_billings.dart';
import 'package:fanfan/service/schemas/billing.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql/client.dart';

Future<PaginatedBillings> queryBillings() async {
  final response = await Client().query(
    QueryOptions(
      document: BILLINGS,
    ),
  );

  if (response.hasException || response.data == null) {
    reject([
      ...(response.exception?.graphqlErrors ?? []),
      const GraphQLError(message: '获取失败！')
    ]);
  }

  return PaginatedBillings.fromJson(response.data!['billings']);
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
    reject([
      ...(response.exception?.graphqlErrors ?? []),
      const GraphQLError(message: '创建失败！')
    ]);
  }

  return Billing.fromJson(response.data!['createBilling']);
}
