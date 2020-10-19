import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class LogoutProvider {
  Future<bool> logout() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toLogout)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    }).catchError((exception) {
      print('catch error $exception');
      ExceptionHandler.handleError(exception);
    });
  }

  QueryOptions _queryOptions() {
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly, documentNode: gql(_logoutQuery));
  }

  bool _toLogout(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final res = queryResult.data['logout'];

    return res;
  }

  String get _logoutQuery => '''
    mutation {
      logout
    }
    ''';
}
