import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class LoginProvider {
  Future<AuthModel> login(AuthLoginWhere where, DeviceInfoModel input) {
    return getGraphQLClient()
        .query(_queryOptions(where, input))
        .then(_toLogin)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(AuthLoginWhere where, DeviceInfoModel input) {
    print(authLogin(where.toJSON(), input.toJSON()));
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(authLogin(where.toJSON(), input.toJSON())),
    );
  }

  AuthModel _toLogin(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final dynamic json = queryResult.data['auth'] as dynamic;

    return AuthModel.fromJson(json);
  }
}

String authLogin(Map<String, dynamic> where, Map<String, dynamic> input) => '''
mutation {
  auth(
    where: $where, 
    input: $input
    ) {
      userId
      token {
        accessToken
        refreshToken
        refreshTokenExpireTime
      }
      user{
        loginType
        profile{
          email
          birthDay
          birthMonth
          birthYear
        }
        company{
          companyCode
        }
        alarmAgreement{
          marketingAlarm
        }
      }
    }
}
''';
