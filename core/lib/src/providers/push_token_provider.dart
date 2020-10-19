import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';
import '../utils/graphql_client.dart';

class PushTokenProvider {
  Future<bool> updatePushToken(String uuid, String pushToken) {
    // print('position type $positionTypes');
    return getGraphQLClient()
        .query(_queryOptions(uuid, pushToken))
        .then(_toUpdatePushToken)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String uuid, String pushToken) {
    final query = readUpdatePushToken(uuid, pushToken);
    print('pushtoken $query');

    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  bool _toUpdatePushToken(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final dynamic json = queryResult.data['updatePushToken'] as dynamic;
    return json;
  }

  String readUpdatePushToken(String uuid, String pushToken) => '''
  mutation {
    updatePushToken(input: {
      uuid: ${json.encode(uuid)},
      token: ${json.encode(pushToken)},
    })
  }
  ''';
}
