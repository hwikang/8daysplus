import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/alarm_agreement_model.dart';

class MyPageSettingProvider {
  Future<Map<String, dynamic>> myPageSetting() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toSettingConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    print(_readSettingConnectionQuery());
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readSettingConnectionQuery()));
  }

  Map<String, dynamic> _toSettingConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final dynamic servicePolicyInfoJson = queryResult.data['servicePolicyInfo'];
    final servicePolicyInfo =
        ServicePolicyInfoModel.fromJson(servicePolicyInfoJson);

    final dynamic alarmAgreementJson =
        queryResult.data['user']['alarmAgreement'];
    final alarmAgreement = AlarmAgreementModel.fromJson(alarmAgreementJson);

    final map = <String, dynamic>{
      'servicePolicyInfo': servicePolicyInfo,
      'alarmAgreement': alarmAgreement
    };
    print('map $map');
    print('marketingAlarm ${alarmAgreement.marketingAlarm}');
    print('orderAlarm ${alarmAgreement.orderAlarm}');
    print('customerAlarm ${alarmAgreement.customerAlarm}');

    // return json;
    return map;
  }

  String _readSettingConnectionQuery() => '''
    {
    servicePolicyInfo {
      serviceUseTermsUrl 
      couponPolicyUrl 
      pointPolicyUrl 
      personalInfoUrl 
      locationUseTermsUrl 
    }
     user {
      alarmAgreement {
          orderAlarm
          customerAlarm
          marketingAlarm
        }
    }
  }
  ''';
}
