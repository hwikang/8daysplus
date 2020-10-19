import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/main/notice_event_model.dart';
import '../../utils/graphql_client.dart';

class NoticeEventProvider {
  Future<NoticeEventModel> noticeEvent(String id) {
    // print('position type $positionTypes');
    return getGraphQLClient()
        .query(_queryOptions(id))
        .then(_toNoticeEvent)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String id) {
    final query = readNoticeEvent(id);
    print('query $query');

    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  NoticeEventModel _toNoticeEvent(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final model = NoticeEventModel.fromJson(queryResult.data['noticeEvent']);
    return model;
  }

  String readNoticeEvent(String id) => '''
  {
 
  noticeEvent(id: ${json.encode(id)}) {
    id
    title
    imageActionLinks {
      coverImage {
        url
      }
      actionLink {
        target
        value
      }
    }
  }

}
  ''';
}
