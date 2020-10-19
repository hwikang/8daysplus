import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/inquiry_list_model.dart';

class InquiryListProvider {
  Future<Map<String, dynamic>> inquiryConnection(int first, String after) {
    return getGraphQLClient()
        .query(_queryOptions(first, after))
        .then(_toInquiryConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(int first, String after) {
    var afterQuery = '';
    if (after.isNotEmpty) {
      afterQuery = "after:'$after'";
    }
    print(readInquiryConnectionQuery(first, afterQuery));

    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readInquiryConnectionQuery(first, afterQuery)));
  }

  Map<String, dynamic> _toInquiryConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> edges = queryResult.data['inquiryConnection']['edges'];
    var lastCursor = '';
    var inquiryList = <InquiryListModel>[];
    if (edges.isNotEmpty) {
      lastCursor = edges[edges.length - 1]['cursor'];
      inquiryList = edges
          .map(
              (dynamic repoJson) => InquiryListModel.fromJson(repoJson['node']))
          .toList();
    }

    final map = <String, dynamic>{
      'lastCursor': lastCursor,
      'inquiryList': inquiryList,
    };
    print(map);
    return map;
  }

  String readInquiryConnectionQuery(int first, String afterQuery) => '''
  
  {
    inquiryConnection(
      first:$first
      $afterQuery
    ) {
      edges{
        cursor
        node{
          id
          message
          type
          title
          createdAt
          replies {
            message
            createdAt
          }
        }
      }
    }
  }
  ''';
}
