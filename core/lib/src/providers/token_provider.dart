import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';

import '../../core.dart';

class TokenProvider {
  // Future<bool> signUpProvider(SignUpModel signUpModel) {
  Future<TokenModel> tokenProvider(String refreshToken) {
    return getGraphQLClient()
        .query(_queryOptions(refreshToken))
        .then(_toToken)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(String refreshToken) {
    print('tokenProvider == ${tokenQuery(refreshToken)}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(tokenQuery(refreshToken)));
  }

  TokenModel _toToken(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print('_toToken');
    print(queryResult.data);
    final dynamic json = queryResult.data['token'] as dynamic;
    print('token json === $json');
    return TokenModel.fromJson(json);
  }
}

String tokenQuery(String refreshToken) => '''
mutation{
  token(input:{
    refreshToken : ${json.encode(refreshToken)}
  }) {
    accessToken
    refreshToken
  }
}
''';
