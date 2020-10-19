import '../../../core.dart';

class SendAuthSmsBloc {
  SendAuthSmsProvider sendAuthSmsProvider = SendAuthSmsProvider();
  SendAuthEmailSmsProvider sendAuthEmailSmsProvider =
      SendAuthEmailSmsProvider();
  // final BehaviorSubject<String> _sendAuthSmsController =
  //     BehaviorSubject<String>();

  // Observable<String> get sendMobileStream => _sendAuthSmsController.stream;

  // void dispose() {
  //   _sendAuthSmsController.close();
  // }

//sign up , update user
  Future<bool> sendAuthSms(String countryCode, String mobileNum) {
    final model =
        SendAuthMobileModel(countryCode: countryCode, mobile: mobileNum);

    return sendAuthSmsProvider.sendAuthSms(model).then((result) {
      print('auth mobile $result');
      return result;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

//email find
  Future<bool> sendAuthEmailSms(String countryCode, String mobileNum) {
    final model =
        SendAuthMobileModel(countryCode: countryCode, mobile: mobileNum);

    return sendAuthEmailSmsProvider.sendAuthEmailSms(model).then((result) {
      print('auth mobile $result');
      return result;
    }).catchError((exception) => {ExceptionHandler.handleError(exception)});
  }
}
