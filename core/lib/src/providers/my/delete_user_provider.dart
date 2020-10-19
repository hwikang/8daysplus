import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class DeleteUserProvider {
  Future<bool> deleteUser() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toDeleteUser)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    return QueryOptions(documentNode: gql(_readDeleteUserQuery()));
  }

  bool _toDeleteUser(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final bool result = queryResult.data['deleteUser'];

    return result;
  }

  String _readDeleteUserQuery() {
    return '''
    mutation{ deleteUser
    }
''';
  }
}
