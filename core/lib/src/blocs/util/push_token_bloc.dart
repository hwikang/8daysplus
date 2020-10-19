import '../../../core.dart';

class PushTokenBloc {
  final PushTokenProvider pushTokenProvider = PushTokenProvider();

  Future<bool> updatePushToken(String uuid, String token) {
    return pushTokenProvider
        .updatePushToken(uuid, token)
        .catchError((exception) => {
              ExceptionHandler.handleError(
                exception,
              )
            });
  }
}
