import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/faq_model.dart';
import '../../utils/graphql_client.dart';

class FaqProvider {
  Future<Map<String, dynamic>> faqConnection(
      int first, String after, String type) {
    return getGraphQLClient()
        .query(_queryOptions(first, after, type))
        .then(_toFaqConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(int first, String after, String type) {
    var afterQuery = '';
    if (after.isNotEmpty) {
      afterQuery = 'after:"$after"';
    }
    print(readFaqConnectionQuery(first, afterQuery, type));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readFaqConnectionQuery(first, afterQuery, type)));
  }

  Map<String, dynamic> _toFaqConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final List typeEdges = queryResult.data['faqTypes'];
    final typeList = typeEdges.map((dynamic type) {
      return FaqTypeModel.fromJson(type);
    }).toList();

    final List edges = queryResult.data['faqConnection']['edges'];
    var lastCursor = '';
    var faqList = <FaqModel>[];
    if (edges.isNotEmpty) {
      lastCursor = edges[edges.length - 1]['cursor'];
      faqList = edges
          .map((dynamic repoJson) => FaqModel.fromJson(repoJson['node']))
          .toList();
    }

    final map = <String, dynamic>{
      'lastCursor': lastCursor,
      'faqList': faqList,
      'typeList': typeList
    };
    print(map);
    return map;
  }

  String readFaqConnectionQuery(int first, String afterQuery, String type) =>
      '''
   {
    faqConnection(
      first: $first
      $afterQuery
      where:{
        type:$type
      } 
    ) {
    edges {
      cursor
      node{
        id
        title
        message
        type
      }
    }
  }
    faqTypes{
      type
      name
    }

  }
  ''';
}
