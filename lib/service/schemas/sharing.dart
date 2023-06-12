import 'package:graphql/client.dart';

final CREATE_SHARING = gql(r'''
  mutation CreateSharing($createBy: CreateSharingBy!) {
    createSharing(createBy: $createBy)
  }
''');
