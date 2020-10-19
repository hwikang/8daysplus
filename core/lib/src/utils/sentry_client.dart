import 'package:mobile/utils/singleton.dart';
import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(
    dsn:
        'https://6b9497476a234d0b8a0aab50cb1b89ca@o404773.ingest.sentry.io/5273975');

Future<Event> getSentryEvent(dynamic exception, dynamic stackTrace,
    {dynamic extra}) async {
  return Event(
    exception: exception,
    stackTrace: stackTrace,
    extra: <String, dynamic>{
      'appVersion': Singleton.instance.appVersion,
      'deviceModel': Singleton.instance.deviceModel,
      'osVer': Singleton.instance.osVer,
      'extra': extra ?? ''
    },
  );
}

Future<void> sendErrorReport(dynamic event) async {
  _sentry.capture(
    event: event,
  );
}
