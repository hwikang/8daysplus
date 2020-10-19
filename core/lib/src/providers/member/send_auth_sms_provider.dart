import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

//send auth SMS for signup & update user phone
class SendAuthSmsProvider {
  Future<bool> sendAuthSms(SendAuthMobileModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_authMobile)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(SendAuthMobileModel model) {
    print(' ${sendAuthSmsQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(sendAuthSmsQuery(model.toJSON())));
  }

  bool _authMobile(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);

      throw queryResult.exception;
    }
    getLogger(this).i('sendAuthSms ${queryResult.data['sendAuthSms']}');
    return queryResult.data['sendAuthSms'];
  }

  String sendAuthSmsQuery(Map<String, dynamic> model) => '''
  mutation{
    sendAuthSms(input:$model)
  }  
  ''';
}
