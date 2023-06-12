import 'package:fanfan/service/entities/sharing/main.dart';
import 'package:fanfan/service/schemas/sharing.dart';
import 'package:fanfan/utils/service.dart';
import 'package:graphql/client.dart';

Future<bool> createSharing({
  required int targetId,
  required Type targetType,
  required List<int> sharedByIds,
}) async {
  final response = await Client().mutate(MutationOptions(
    document: CREATE_SHARING,
    variables: {
      "createBy": {
        "targetId": targetId,
        "targetType": targetType.name,
        "sharedByIds": sharedByIds,
      }
    },
  ));

  if (response.hasException || response.data == null) {
    reject(List.from(response.exception?.graphqlErrors ?? [])
      ..add(const GraphQLError(message: '获取失败！')));
  }

  return response.data!['createSharing'];
}
