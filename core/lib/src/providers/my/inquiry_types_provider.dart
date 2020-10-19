import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/inquiry_types_model.dart';

class InquiryTypesProvider {
  Future<List<InquiryTypeModel>> inquiryConnection() {
    return getGraphQLClient()
        .query(_queryOptions())
        .then(_toInquiryTypes)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions() {
    print(readInquiryTypesQuery());

    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readInquiryTypesQuery()));
  }

  List<InquiryTypeModel> _toInquiryTypes(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['inquiryTypes'];

    print(list);
    return list
        .map((dynamic repoJson) => InquiryTypeModel.fromJson(repoJson))
        .toList();
  }

  String readInquiryTypesQuery() => '''
  {
    inquiryTypes {
      name
      type
    }
  }
  ''';
}
