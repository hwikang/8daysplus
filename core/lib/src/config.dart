import 'package:flutter/foundation.dart';

const String GRAPHQL_DEV_URL = 'https://plus-api-dev.the8days.com/graphql';
const String GRAPHQL_URL = 'http://plus-api-release.the8days.com/graphql';

bool debugAPI = !kReleaseMode && !kProfileMode;
