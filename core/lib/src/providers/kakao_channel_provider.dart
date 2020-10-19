import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';
import '../utils/graphql_client.dart';

class KakaoChannelProvider {
  Future<String> getKakaoChannelURL() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toGetKakaoChannel)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    final query = readKakaoChannel();
    print('readKakaoChannel $query');

    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  String _toGetKakaoChannel(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final dynamic json = queryResult.data['kakaoChannel'] as dynamic;
    return json;
  }

  String readKakaoChannel() => '''
  {
    kakaoChannel
  }
  ''';
}
