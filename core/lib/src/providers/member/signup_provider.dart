import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';

class SignUpProvider {
  Future<AuthModel> signUpProvider(SignUpModel signUpModel) {
    return getGraphQLClient()
        .query(_queryOptions(signUpModel))
        .then(_toSignUp)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException('time out in exist email provider');
    });
  }

  QueryOptions _queryOptions(SignUpModel signUpModel) {
    print('signUpQuery == ${signUpQuery(signUpModel.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(signUpQuery(signUpModel.toJSON())));
  }

  AuthModel _toSignUp(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final dynamic signUp = queryResult.data['signup'];
    return AuthModel.fromJson(signUp);
  }
}

String signUpQuery(Map<String, dynamic> model) => '''
mutation{
  signup(input:$model) {
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
