import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/main/feed_alarm_model.dart';

class MainAlarmProvider {
  Future<Map<String, dynamic>> alarmConnection(int first, String after) {
    return getGraphQLClient()
        .query(_queryOptions(first, after))
        .then(_toAlarmConnection)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(int first, String after) {
    print(_readMainAlarmConnectionQuery(first, after));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readMainAlarmConnectionQuery(first, after)));
  }

  Map<String, dynamic> _toAlarmConnection(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    final List<dynamic> list = queryResult.data['alarmConnection']['edges'];

    var map = <String, dynamic>{
      'nodes': <FeedMainAlarmModel>[],
      'lastCursor': ''
    };
    print('list $list ${list.length}');
    if (list.isEmpty) {
      return map;
    }

    final alarmList = list.map((dynamic repoJson) {
      return FeedMainAlarmModel.fromJson(repoJson['node']);
    }).toList();
    print(alarmList.length);
    final String lastCursor = list[list.length - 1]['cursor'];
    map = <String, dynamic>{'nodes': alarmList, 'lastCursor': lastCursor};
    return map;
  }

  String _readMainAlarmConnectionQuery(int first, String after) => '''
    {
      alarmConnection(first: $first,after:${json.encode(after)}) {
        edges{
          cursor
          node {
            id
            name
            type
            createdAt
            message {
              imageInfo {
                url
              }
              name
              price
            }
            actionLink {
              value
              target
            }
          }
        }        
      }
    }
    ''';
}
