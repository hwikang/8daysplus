import 'dart:async';

import 'package:graphql/client.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

//use in signup , update user
class ConfirmAuthSmsProvider {
  Future<bool> confirmAuthSms(ConfirmAuthSmsModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_confirmAuthSms)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(
          '접속이 지연되고 있습니다.\n네트워크 연결 상태를 확인하거나,\n잠시 후 다시 이용해 주세요.');
    });
  }

  QueryOptions _queryOptions(ConfirmAuthSmsModel model) {
    print('dddd ${confirmAuthSmsQuery(model.toJSON())}');
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(confirmAuthSmsQuery(model.toJSON())));
  }

  bool _confirmAuthSms(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print('zxcv ${queryResult.data}');
    return queryResult.data['confirmAuthSms'];
  }

  String confirmAuthSmsQuery(Map<String, dynamic> model) => '''
  mutation{
    confirmAuthSms(input:$model)
  }  
  ''';
}
