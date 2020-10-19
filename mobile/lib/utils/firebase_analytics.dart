// analytics
import 'dart:async';

import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// utils
// import 'package:application_name/utils/analytics/analytics_event_type.dart';

mixin Analytics {
  // static String _isEventType;
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // // logEvent()
  // static Future analyticsLogEvent(
  //     AnalyticsEventType eventType, Map<String, dynamic> parameterMap) async {
  //   _isEventType = await _enumToString(eventType);
  //   await analytics.logEvent(
  //     name: _isEventType,
  //     parameters: parameterMap,
  //   );
  // }

  // // Convert the value defined Enum to String
  // static Future _enumToString(eventType) async {
  //   return eventType.toString().split('.')[1];
  // }

  static Future<void> analyticsLogEvent(
      String eventName, Map<String, dynamic> parameterMap) async {
    await analytics
        .logEvent(
      name: eventName,
      parameters: parameterMap,
    )
        .catchError((dynamic err) {
      getSentryEvent(err, 'analytics log event', extra: <String, dynamic>{
        'parameterMap': parameterMap,
        'eventName': eventName
      }).then(sendErrorReport);
    });
  }

  static Future<void> analyticsSetUserId(String userId) async {
    await analytics.setUserId(userId);
  }

  static Future<void> analyticsScreenName(String screeName) async {
    await analytics.setCurrentScreen(screenName: screeName);
  }

  static Future<void> analyticsSetUserProperty(
      String name, String value) async {
    await analytics.setUserProperty(name: name, value: value);
  }
}
