import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';

class InquiryCreateProvider {
  Future<bool> createInquiry(InquiryCreateModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_toSignUp)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(InquiryCreateModel model) {
    print(createInquiryQuery(model.toJson()));
    return QueryOptions(documentNode: gql(createInquiryQuery(model.toJson())));
  }

  bool _toSignUp(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final dynamic json = queryResult.data['createInquiry'];
    // print(json);
    return json;
  }
}

String createInquiryQuery(Map<String, dynamic> model) => '''
  mutation {
    createInquiry(input: $model)
  }
''';
