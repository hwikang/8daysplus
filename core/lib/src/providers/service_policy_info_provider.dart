import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';
import '../utils/graphql_client.dart';

class ServicePolicyInfoProvider {
  Future<ServicePolicyInfoModel> servicePolicyInfo() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toServicePolicyInfo)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    print(_readServicePolicyInfoQuery());
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readServicePolicyInfoQuery()));
  }

  ServicePolicyInfoModel _toServicePolicyInfo(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final dynamic servicePolicyInfoJson = queryResult.data['servicePolicyInfo'];
    final servicePolicyInfo =
        ServicePolicyInfoModel.fromJson(servicePolicyInfoJson);

    return servicePolicyInfo;
  }

  String _readServicePolicyInfoQuery() => '''
    {
    servicePolicyInfo {
      serviceUseTermsUrl 
      couponPolicyUrl 
      pointPolicyUrl 
      personalInfoUrl 
      locationUseTermsUrl 
    }
     
  }
  ''';
}
