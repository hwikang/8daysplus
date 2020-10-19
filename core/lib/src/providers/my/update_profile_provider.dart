import 'dart:async';

import 'package:graphql/client.dart';
import 'package:mobile/utils/strings.dart';

import '../../../core.dart';
import '../../models/my/profile/update_profile_input_model.dart';
import '../../utils/graphql_client.dart';

class UpdateProfileProvider {
  Future<bool> updateProfile(UpdateProfileInputModel model) {
    return getGraphQLClient()
        .query(_queryOptions(model))
        .then(_toUpdateProfile)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      throw TimeoutException(ErrorTexts.networkError);
    });
  }

  QueryOptions _queryOptions(UpdateProfileInputModel model) {
    print(_readUpdateProfileQuery(model.toJSON()));
    return QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        documentNode: gql(_readUpdateProfileQuery(model.toJSON())));
  }

  bool _toUpdateProfile(QueryResult queryResult) {
    if (queryResult.hasException) {
      getLogger(this).w(queryResult.exception);
      throw queryResult.exception;
    }
    print(queryResult.data);
    final bool result = queryResult.data['updateProfile'];
    return result;
  }

  String _readUpdateProfileQuery(Map<String, dynamic> profileInput) {
    return '''
      mutation{ updateProfile(input: $profileInput)
    }
    ''';
  }
}
