import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/alarm_agreement_model.dart';
import '../../utils/graphql_client.dart';

class UpdateAlarmAgreementProvider {
  Future<bool> updateAlarmAgreement(AlarmAgreementModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_toUpdateAlarmAgreement)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(AlarmAgreementModel model) {
    print(_readUpdateAlarmAgreementQuery(model.toJSON()));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readUpdateAlarmAgreementQuery(model.toJSON())));
  }

  bool _toUpdateAlarmAgreement(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(
        '_toUpdateAlarmAgreement ${queryResult.data['updateAlarmAgreement']}');
    final bool result = queryResult.data['updateAlarmAgreement'];
    return result;
  }

  String _readUpdateAlarmAgreementQuery(Map<String, dynamic> model) {
    return '''
    mutation{ 
      updateAlarmAgreement(input: $model)
    }
    ''';
  }
}
