import 'dart:io';

import 'package:graphql/client.dart';
import 'package:mobile/utils/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

HttpLink getHttpLink() {
  final uuid = Singleton.instance.sUUID;
  final os = Singleton.instance.sPlatform;

  // 실서버 배포용
  if (debugAPI) {
    print(GRAPHQL_DEV_URL);
    Singleton.instance.serverUrl = GRAPHQL_DEV_URL;
    return HttpLink(
        uri: '$GRAPHQL_DEV_URL',
        headers: <String, String>{'os': os, 'uuid': uuid});
  } else {
    print(GRAPHQL_URL);
    Singleton.instance.serverUrl = GRAPHQL_URL;
    return HttpLink(
        uri: '$GRAPHQL_URL', headers: <String, String>{'os': os, 'uuid': uuid});
  }
}

final HttpLink _httpLink = getHttpLink();

final AuthLink _authLink = AuthLink(getToken: () async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
  // return 'fakeToken';
});

final Link _link = _authLink.concat(_httpLink);

GraphQLClient _client;
GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: _link,
    cache: NormalizedInMemoryCache(
      dataIdFromObject: typenameDataIdFromObject,
    ),
  );
  return _client;
}

String typenameDataIdFromObject(Object object) {
  if (object is Map<String, Object> &&
      object.containsKey('__typename') &&
      object.containsKey('id')) {
    return '${object['__typename']}/${object['id']}';
  }
  return null;
}
