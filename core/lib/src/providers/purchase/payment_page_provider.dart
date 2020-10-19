import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../utils/graphql_client.dart';

class PaymentPageProvider {
  Future<Map<String, dynamic>> paymentPage() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toPamentPage)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    print(readPaymentPageQuery());
    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(readPaymentPageQuery()),
    );
  }

  Map<String, dynamic> _toPamentPage(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final int lifePoint = queryResult.data['lifePoint'];

    final List<dynamic> cards = queryResult.data['cardCodes'];
    final List<dynamic> paymentMethodCodes =
        queryResult.data['paymentMethodCodes'];
    final cardCodes = cards.map((dynamic card) {
      return CreditCardModel.fromJson(card);
    }).toList();
    final paymentMethods = paymentMethodCodes.map((dynamic paymentMethod) {
      return PaymentMethodModel.fromJson(paymentMethod);
    }).toList();
    final servicePolicyInfo =
        ServicePolicyInfoModel.fromJson(queryResult.data['servicePolicyInfo']);

    final map = <String, dynamic>{
      'lifePoint': lifePoint,
      'servicePolicyInfo': servicePolicyInfo,
      'cardCodes': cardCodes,
      'paymentMethods': paymentMethods,
    };
    print(map);
    return map;
  }

  String readPaymentPageQuery() => '''
  {

    lifePoint

    servicePolicyInfo {
      serviceUseTermsUrl 
      couponPolicyUrl 
      pointPolicyUrl
      personalInfoUrl 
      locationUseTermsUrl 
      thirdTermsUrl
      elecTermsUrl
    }
    cardCodes {
      code
      name
    }
    paymentMethodCodes {
      coverImage {
        url
      }
      type
    }
  }
    
  ''';
}
