import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../core.dart';

class VersionProvider {
  Future<VersionModel> version(String os, String av) {
    // print('position type $positionTypes');
    return getGraphQLClient()
        .query(_queryOptions(os, av))
        .then(_toVersion)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(String os, String av) {
    final query = readVersion(os, av);
    print('version query $query');

    return QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: gql(query),
    );
  }

  VersionModel _toVersion(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }

    final dynamic json = queryResult.data['version'];
    return VersionModel.fromJson(json);
  }

  String readVersion(String os, String av) => '''
  query {
    version(os: ${json.encode(os)}, av: ${json.encode(av)}) {
      isUpdate
      isForceUpdate
      version
      downloadURL
      comment
    }
  }
  ''';
}
