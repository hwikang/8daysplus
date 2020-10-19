import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/notice_list_view_model.dart';

class NoticeListProvider {
  Future<List<NoticeListViewModel>> noticeConnection(int first) {
    return getGraphQLClient()
        .query(_queryOptions(first))
        .then(_toNoticeConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(int first) {
    print(readNoticeConnectionQuery(first));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(readNoticeConnectionQuery(first)));
  }

  List<NoticeListViewModel> _toNoticeConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['noticeConnection']['edges'];

    print(list);
    return list
        .map((dynamic repoJson) =>
            NoticeListViewModel.fromJson(repoJson['node']))
        .toList();
  }

  String readNoticeConnectionQuery(int first) => '''
  
  query noticeConnection{
    noticeConnection(
      first:$first
    ){
      edges{
        cursor
        node {
          id
          type
          title
          createdAt
            message
            images{
              url
            }
            isNew
        }
      }
    }
  }
  ''';
}
