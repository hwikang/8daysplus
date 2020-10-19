import 'dart:async';
import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/profile/update_password_model.dart';
import '../../utils/graphql_client.dart';

class UpdatePasswordProvider {
  Future<bool> updatePasswordConnection(UpdatePasswordModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_toUpdatePasword)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(UpdatePasswordModel model) {
    print(_readUserConnectionQuery(model.toJSON()));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readUserConnectionQuery(model.toJSON())));
  }

  bool _toUpdatePasword(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final bool result = queryResult.data['updatePassword'];
    return result;
  }

  String _readUserConnectionQuery(Map<String, String> input) => '''
  mutation{
    updatePassword(input: {
      newPassword:${json.encode(input['newPassword'])},
      oldPassword:${json.encode(input['oldPassword'])}
    })
  }
  ''';
}
